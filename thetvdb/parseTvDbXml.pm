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

my $VERSION = 1.00;

sub new {
  my $classname = shift;
  my $self = {
    ROWS                  => 1
  };
  $self->{table_html_loop} = (); # list contains the row entries
  
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

sub someFct {
  my($self) = shift;
  if (scalar(@_) % 2 == 0) {
    # get the paramters, which are given as a hash
  }
}