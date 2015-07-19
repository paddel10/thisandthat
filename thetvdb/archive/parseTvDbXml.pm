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
use Archive::Zip qw( :ERROR_CODES :CONSTANTS );
use XML::LibXML;
use Data::Dumper;
use lib ".";
use retrieveSeries;

my $VERSION = 1.00;

sub new {
  my $classname = shift;
  my $self = {
    DEBUG => 0,
    xml => undef
  };

  $self->{xml} = XML::LibXML->new() or die "could not create XML object";

  bless($self, $classname);

  return $self;
}

sub version {
  my($self) = shift;
  return $VERSION;
}

##
# Retrieve server time of thetvdb.com
#
# @return server time
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
# Retrieves information of given series and returns it as list
#
# @param seriesId id of series
# @param apiKey api key to access service
# @return list containing information about series. Every item is a list containing
# the following items: seriesId, seasonId, episodeId, seasonNumber, episodeNumber,
# firstAired, episodeName
#
##
sub retrieveSerie {
  my($self) = shift;
  my($seriesId, $apiKey) = @_;

  # get zip file
  my $zipFile = retrieveSerieAsZip($seriesId, $apiKey);
  die "failed (" . $zipFile . ")" if (0 > $zipFile);

  # unpack
  my $seriesZip = Archive::Zip->new();
  my $status = $seriesZip->read($zipFile);
  die "read error" if ($status != AZ_OK);
  $status = $seriesZip->extractMember("en.xml");
  die "could not extract en.xml" if ($status != AZ_OK);

  # parse
  my $parsed_xml = $self->{xml}->parse_file("en.xml") or die "could not parse XML object";

  my @series_list = ();
  for my $episode ($parsed_xml->findnodes("/Data/Episode")) {
    my $ep_seriesId = $episode->findnodes('./seriesid')->string_value();
    my $ep_seasonId = $episode->findnodes('./seasonid')->string_value();
    my $ep_id = $episode->findnodes('./id')->string_value();
    my $ep_seasonNumber = $episode->findnodes('./SeasonNumber')->string_value();
    my $ep_episodeNumber = $episode->findnodes('./EpisodeNumber')->string_value();
    my $ep_firstAired = $episode->findnodes('./FirstAired')->string_value();
    my $ep_episodeName = $self->trim($episode->findnodes('./EpisodeName')->string_value());
    
    my @episode_list = (
      $ep_seriesId,
      $ep_seasonId,
      $ep_id,
      $ep_seasonNumber,
      $ep_episodeNumber,
      $ep_firstAired,
      $ep_episodeName
    );
    push(@series_list, [ @episode_list ]);
  }

  # cleanup
  unlink $zipFile;
  #unlink "en.xml";

  return @series_list;
}

sub retrieveSerie2 {
  my($self) = shift;
  my($seriesId, $apiKey, $loopNode, @nodes) = @_;

  # get zip file
  my $zipFile = retrieveSerieAsZip($seriesId, $apiKey);
  die "failed (" . $zipFile . ")" if (0 > $zipFile);

  # unpack
  my $seriesZip = Archive::Zip->new();
  my $status = $seriesZip->read($zipFile);
  die "read error" if ($status != AZ_OK);
  $status = $seriesZip->extractMember("en.xml");
  die "could not extract en.xml" if ($status != AZ_OK);

  # parse
  my $parsed_xml = $self->{xml}->parse_file("en.xml") or die "could not parse XML object";

  my @series_list = ();
  for my $episode ($parsed_xml->findnodes($loopNode)) {
    my @episode_list = ();
    for my $node (@nodes) {
      push(@episode_list, $self->trim($episode->findnodes($node)->string_value()));
    }
    push(@series_list, [ @episode_list ]);
  }

  # cleanup
  unlink $zipFile;
  unlink "en.xml";

  return @series_list;
}

sub retrieveSerieEpisodeDayUpdates {
  my($self) = shift;
  my($apiKey) = shift;
  my $updates = retrieveDayUpdates($apiKey);
  
  my $parsed_xml = $self->{xml}->parse_string($updates) or die "could not parse XML object";
  print "Dumper: \n";
  for my $item ($parsed_xml->findnodes("/Data")) {
    for my $serie ($item->findnodes("./Series")) {
      print "serieId: " . $serie->findnodes("./id")->string_value() . "\n";
    }
    for my $episode ($item->findnodes("./Episode")) {
      print "episodeId: " . $episode->findnodes("./id")->string_value() . ", " . $episode->findnodes("./Series")->string_value() . "\n";
    }
  }
  
}

sub  trim {
  my($self) = shift;
  my($s) = shift;
  $s =~ s/^\s+|\s+$//g;
  return $s
};


