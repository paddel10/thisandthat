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

package retrieveSeries;
use strict;
use vars qw(@ISA @EXPORT $VERSION);
use Exporter;

@ISA     = qw(Exporter);
@EXPORT  = qw(&retrieveSerieAsZip &retrieveServerTime &retrieveDayUpdates);
$VERSION = 1.00;

use warnings;
use Data::Dumper;
use File::Basename;
use File::Spec;
use LWP::Simple qw($ua getstore get is_error);
use URI;
use Cwd;

#-----------------------------------------------------------------------
# @functionName     retrieveSerieAsZip
# @description      Download zipped serie from thetvdb.com
# @param            serie id to retrieve
# @param            api key to access thetvdb.com API
# @param            path/filename with no suffix where to store the zip file
# @return           fail: negative error number of getstore(), success: path/filename
#                   with .zip suffix where the zip file was stored 
#-----------------------------------------------------------------------
sub retrieveSerieAsZip {
    my($seriesId, $apiKey, $zipDest) = @_;
    
    if (!defined $zipDest) {
      $zipDest = File::Spec->catfile(getcwd, $seriesId . ".zip");
    } else {
      $zipDest .= ".zip";
    }

    my $patternUrl = "http://thetvdb.com/api/%s/series/%d/all/en.zip";

    my $seriesUrl = sprintf($patternUrl, $apiKey, $seriesId);

    my $url = URI->new($seriesUrl);

    $ua->default_headers(HTTP::Headers->new(Accept => '*/*'));
    $ua->agent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_3) AppleWebKit/534.54.16 (KHTML, like Gecko) Version/5.1.4 Safari/534.54.16");
    my $ret = getstore($url, $zipDest);
    return (0-$ret) if (is_error($ret));
    return $zipDest;
}

#-----------------------------------------------------------------------
# @functionName     retrieveServerTime
# @description      Retrieve server time from thetvdb.com
# @return           fail: negative error number of get()
#                   success: server time as XML structure
#-----------------------------------------------------------------------
sub retrieveServerTime {
    return retrieveContent("http://thetvdb.com/api/Updates.php?type=none");
}

#-----------------------------------------------------------------------
# @functionName     retrieveDayUpdates
# @description      Retrieve updates of the last 24 hours
# @return           fail: negative error number of get()
#                   success: updates as XML structure
#-----------------------------------------------------------------------
sub retrieveDayUpdates {
    my($apiKey) = @_;
    return retrieveContent(sprintf("http://thetvdb.com/api/%s/updates/updates_day.xml", $apiKey));
}
#-----------------------------------------------------------------------
# @functionName     retrieveUpdates
# @description      Retrieve updates since last server time
# @return           fail: negative error number of get()
#                   success: server time as XML structure
#-----------------------------------------------------------------------
#sub retrieveUpdates {
#    my($serverTime) = @_;
#    return retrieveContent(sprintf("http://thetvdb.com/api/Updates.php?type=all&time=%d", $serverTime));
#}

#-----------------------------------------------------------------------
# @functionName     retrieveContent
# @description      Generic retrieval
# @return           fail: negative error number of get()
#                   success: server time as XML structure
#-----------------------------------------------------------------------
sub retrieveContent {
    my $b = shift;
    print $b;
    my $url = URI->new($b);

    $ua->default_headers(HTTP::Headers->new(Accept => '*/*'));
    $ua->agent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_3) AppleWebKit/534.54.16 (KHTML, like Gecko) Version/5.1.4 Safari/534.54.16");
    my $ret = get($url);
    return (0-$ret) if (is_error($ret));
    return $ret;
}
