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
use lib ".";
use parseTvDbXml;
use retrieveSeries;

my $apiKey;
my $help;

GetOptions("apiKey=s" => \$apiKey,
           "help|?|h" => \$help) or die("Error in command line arguments\n");

help() if ($help or !$apiKey);

my $parser = new parseTvDbXml();

# Get a list of all series and episode updates from the last 24h
print $parser->retrieveSerieEpisodeDayUpdates($apiKey);

# Update each series in the update XML
# http://thetvdb.com/api/<api-key>/series/294332/en.xml

# Update each episode in the update XML
# http://thetvdb.com/api/<api-key>/episodes/4239317/en.xml

# Record <previoustime> for next update

print "\ndone\n";

sub help {
  print <<HELP

Script downloads information from http://www.thetvdb.com about updated series
after a given time.
The downloaded ZIP file is extracted and the XML file parsed in order to
retrieve the updated episodes from the serie.

$0 [options]

options:
  -apiKey <tvDbAPIKey>      API key for accessing thetvdb.com content
  -header                   (optional) If set, column header is printed
  -h|help|?                 (optional) This page

HELP
;
  exit 0;
}