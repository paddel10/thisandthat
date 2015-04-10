#!/usr/bin/perl

use strict;

use Getopt::Long;
use lib ".";
use retrieveSeries;

my $apiKey;
my $seriesId;
my $help;

GetOptions("apiKey=s" => \$apiKey,
           "seriesId=i" => \$seriesId,
           "help|?|h" => \$help) or die("Error in command line arguments\n");

help() if ($help or !$apiKey or !$seriesId);

print "done\n";

sub help {
  print <<HELP

Script downloads information about a given serie from http://www.thetvdb.com.
The downloaded ZIP file is extracted and the XML file parsed in order to
retrieve the episodes from the serie.

$0 [options]

options:
  -apiKey <tvDbAPIKey>    API key for accessing thetvdb.com content
  -seriesId <seriesId>    Id of the serie as integer
  -h|help|?               (optional) This page

HELP
;
  exit 0;
}