#!/usr/bin/perl

package retrieveSeries;
use strict;
use vars qw(@ISA @EXPORT $VERSION);
use Exporter;

@ISA     = qw(Exporter);
@EXPORT  = qw(&retrieveSerieAsZip);
$VERSION = 1.00;

use warnings;
use Data::Dumper;
use File::Basename;
use File::Spec;
use LWP::Simple qw($ua getstore is_error);
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
