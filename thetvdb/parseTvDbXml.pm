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
package parseTvDbXml;

use strict;
#use warnings;
use Template;
use CGI ':standard';
use lib ".";
use retrieveSeries;

my $VERSION = 1.00;

sub new {
  my $classname = shift;
  my $self = {
    DEBUG => 0
  };

  $self->xml = XML::LibXML->new() or die "could not create XML object";

  bless($self, $classname);

  if(scalar(@_) % 2 == 0) {
    # get the paramters, which are given as a hash
    my %hashargs = @_;
    foreach my $key(keys %hashargs) {
      if(exists $self->{$key}) {
        $self->{$key} = $hashargs{$key};
      } else {
        print_debug($self, "Parameter $key isn't supported.") if $self->{DEBUG};
      }
    }
  } else {
    print_debug($self, "Missing or ambiguous arguments.") if $self->{DEBUG};
  }
  return $self;
}

sub version {
  my($self) = shift;
  return $VERSION;
}

##
#
#
##
sub getServerTime {
  my($self) = shift;
  my $serverTime = retrieveServerTime();
  die "failed to retrieve server time (" . $serverTime . ")" if (0 > $serverTime);

  my $parsed_xml = $self->{xml}->parse_string($serverTime) or die "could not parse XML object";
  return $parsed_xml->findnodes("/Items/Time");
}

##
#
#
##
sub retrieveSerieAsZip {
  my($self) = shift;
  my($seriesId, $apiKey) = @_;
  my $zipFile = retrieveSerieAsZip($seriesId, $apiKey);
  die "failed (" . $zipFile . ")" if (0 > $zipFile);
  return $zipFile;
}

sub parseFile {

}

sub parseString {

}

sub someFct {
  my($self) = shift;
  if (scalar(@_) % 2 == 0) {
    # get the paramters, which are given as a hash
  }
}

sub print_debug
{
  my($self, $line) = @_;
  my $subname = (caller(1))[3];
  $subname =~ s/\w+::(\w+)/$1/; # remove package name
  return if ($self->{DEBUG} !~ /$subname/);
  print "$subname: $line" .  $self->{line_ending};
}