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

my $apiKey;
my $seriesId;
my $zipDest;
my $help;

GetOptions("apiKey=s" => \$apiKey,
           "seriesId=i" => \$seriesId,
           "zipDest=s" => \$zipDest,
           "help|?|h" => \$help) or die("Error in command line arguments\n");

help() if ($help or !$apiKey or !$seriesId);

print "Retrieving serie id = " . $seriesId . " ... ";
my $zipFile = retrieveSerieAsZip($seriesId, $apiKey, $zipDest);
if (0 > $zipFile) {
  print "failed (" . $zipFile . ")";
  exit $zipFile;
} else {
  print $zipFile;
}

print "Unpacking ...";
my $seriesZip = Archive::Zip->new();
my $status = $seriesZip->read($zipFile);
die "read error" if ($status != AZ_OK);
$status = $seriesZip->extractMember("en.xml");
die "could not extract en.xml" if ($status != AZ_OK);

## loop <Episode> start

#<Data><Episode>
#<id>
#<seriesid>
#<seasonid>
#<SeasonNumber>
#<EpisodeNumber>
#<FirstAired>
#<EpisodeName>
#- update or insert episode

## loop <Episode> end

sub help {
  print <<HELP

Script downloads information about a given serie from http://www.thetvdb.com.
The downloaded ZIP file is extracted and the XML file parsed in order to
retrieve the episodes from the serie.

$0 [options]

options:
  -apiKey <tvDbAPIKey>      API key for accessing thetvdb.com content
  -seriesId <seriesId>      Id of the serie as integer
  -zipDest <path/filename>  (optional) path/filename with no suffix where to
                            store the zip file. Current directory/seriesId is
                            used if this option is omitted.
  -h|help|?                 (optional) This page

HELP
;
  exit 0;
}