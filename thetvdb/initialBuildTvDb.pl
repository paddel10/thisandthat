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
use Data::Dumper;
use lib ".";
use parseTvDbXml;

my $apiKey;
my $seriesId;
my $verbose;
my $header;
my $help;

GetOptions("apiKey=s" => \$apiKey,
           "seriesId=i" => \$seriesId,
           "verbose" => \$verbose,
           "header" => \$header,
           "help|?|h" => \$help) or die("Error in command line arguments\n");

help() if ($help or !$apiKey or !$seriesId);

my $parser = new parseTvDbXml();

print "Retrieve server time ... " if ($verbose);
my $serverTime = $parser->getServerTime();
print $serverTime . "\n";

print "Retrieve serie ... \n" if ($verbose);
print "seriesId|seasonId|episodeId|seasonNr|episodeNr|airdate|episodeName\n" if ($header);
my @serie_list = $parser->retrieveSerie($seriesId, $apiKey);

binmode(STDOUT, ":utf8"); # prevent warning: "Wide character in print"
for my $episode_list_ref (@serie_list) {
    print join('|', @{$episode_list_ref}) . "\n";
}


#print Dumper(@serie_list);

print "finished.\n" if ($verbose);
exit;

sub help {
  print <<HELP

Script downloads information about a given serie from http://www.thetvdb.com.
The downloaded ZIP file is extracted and the XML file parsed in order to
retrieve the episodes from the serie.

$0 [options]

options:
  -apiKey <tvDbAPIKey>      API key for accessing thetvdb.com content
  -seriesId <seriesId>      Id of the serie as integer
  -header                   (optional) If set, column header is printed
  -verbose                  (optional) If set, script prints more information
                            during runtime
  -h|help|?                 (optional) This page

HELP
;
  exit 0;
}