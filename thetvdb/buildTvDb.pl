#!/usr/bin/perl

use strict;

use Getopt::Long;
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
my $ret = retrieveSerieAsZip($seriesId, $apiKey, $zipDest);
if (0 > $ret) {
  print "failed (" . $ret . ")";
} else {
  print $ret;
}

print "\ndone\n";

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