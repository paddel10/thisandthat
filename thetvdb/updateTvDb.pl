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

my $apiKey;
my $serverTime;
my $help;

GetOptions("apiKey=s" => \$apiKey,
           "serverTime=s" => \$serverTime
           "help|?|h" => \$help) or die("Error in command line arguments\n");

help() if ($help or !$apiKey or !$seriesId);

# Get a list of all series and episode updates
http://thetvdb.com/api/Updates.php?type=all&time=<previoustime>

# Update each series in the update XML
http://thetvdb.com/api/<api-key>/series/294332/en.xml

# Update each episode in the update XML
http://thetvdb.com/api/<api-key>/episodes/4239317/en.xml

# Record <previoustime> for next update