#!/usr/bin/perl
# This file is part of thetvdb.
#
# thetvdb is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# thetvdb is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with thetvdb. If not, see <http://www.gnu.org/licenses/>.

use strict;

use Getopt::Long;
use Archive::Zip qw( :ERROR_CODES :CONSTANTS );
use lib ".";
use retrieveSeries;
use XML::LibXML;
use Data::Dumper;

my $apiKey;
my $seriesId;
my $help;

GetOptions("apiKey=s" => \$apiKey,
           "seriesId=i" => \$seriesId,
           "help|?|h" => \$help) or die("Error in command line arguments\n");

help() if ($help or !$apiKey or !$seriesId);

print "Retrieve server time ... ";
my $serverTime = retrieveServerTime();
if (0 > $serverTime) {
  print "failed to retrieve server time (" . $serverTime . ")";
  exit $serverTime;
}

my $xml = XML::LibXML->new() or die "could not create XML object";
my $parsed_xml = $xml->parse_string($serverTime) or die "could not parse XML object";
$serverTime = $parsed_xml->findnodes("/Items/Time");
print $serverTime . "\n";

print "Retrieving serie id = " . $seriesId . " ... ";
my $zipFile = retrieveSerieAsZip($seriesId, $apiKey);
if (0 > $zipFile) {
  print "failed (" . $zipFile . ")";
  exit $zipFile;
}

print $zipFile;

print "\nUnpacking ... ";
my $seriesZip = Archive::Zip->new();
my $status = $seriesZip->read($zipFile);
die "read error" if ($status != AZ_OK);
$status = $seriesZip->extractMember("en.xml");
die "could not extract en.xml" if ($status != AZ_OK);

print "parsing ...\n";
my $xml = XML::LibXML->new() or die "could not create XML object";
my $parsed_xml = $xml->parse_file("en.xml") or die "could not parse XML object";

for my $episode ($parsed_xml->findnodes("/Data/Episode")) {
  my $ep_seriesId = $episode->findnodes('./seriesid');
  my $ep_id = $episode->findnodes('./id');
  my $ep_seasonId = $episode->findnodes('./seasonid');
  my $ep_seasonNumber = $episode->findnodes('./SeasonNumber');
  my $ep_episodeNumber = $episode->findnodes('./EpisodeNumber');
  my $ep_firstAired = $episode->findnodes('./FirstAired');
  my $ep_episodeName = $episode->findnodes('./EpisodeName');

  # update or insert episode
  print $ep_seriesId . "|" . $ep_id . "|" . "S" . sprintf("%02d", $ep_seasonNumber) . "E" . sprintf("%02d", $ep_episodeNumber) . "|" . $ep_firstAired . "|" . $ep_episodeName . "\n";
}


# cleanup
print "cleanup ... ";
unlink $zipFile;
unlink "en.xml";

print "finished.\n";

sub help {
  print <<HELP

Script downloads information about a given serie from http://www.thetvdb.com.
The downloaded ZIP file is extracted and the XML file parsed in order to
retrieve the episodes from the serie.

$0 [options]

options:
  -apiKey <tvDbAPIKey>      API key for accessing thetvdb.com content
  -seriesId <seriesId>      Id of the serie as integer
  -h|help|?                 (optional) This page

HELP
;
  exit 0;
}