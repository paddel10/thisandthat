#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use File::Basename;
use LWP::Simple qw($ua getstore);
use URI;

my $apiKey = "";
my $seriesId = 80337;
my $patternUrl = "http://thetvdb.com/api/%s/series/%d/all/en.zip";

my $seriesUrl = sprintf($patternUrl, $apiKey, $seriesId);

my $url = URI->new($seriesUrl);

$ua->default_headers(HTTP::Headers->new(Accept => '*/*'));
$ua->agent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_3) AppleWebKit/534.54.16 (KHTML, like Gecko) Version/5.1.4 Safari/534.54.16");

my $rc = getstore($url, $seriesId . ".zip");

print "done\n";
