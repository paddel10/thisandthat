<?php
/**
* This file is part of thetvdb.
*
* thetvdb is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* thetvdb is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with thetvdb. If not, see <http://www.gnu.org/licenses/>.
* -----------------------------------------------------------------------------
* Script downloads information about a given serie from http://www.thetvdb.com.
* The downloaded ZIP file is extracted and the XML file parsed in order to
* retrieve the episodes from the serie.
**/
include_once("tvDbParser.php");

$shortopts = "h::a:s:";

$longopts = array(
  "help::",
  "apiKey:",
  "seriesId:"
);

$options = getopt($shortopts, $longopts);

if (array_key_exists("help", $options) || array_key_exists("h", $options) ||
    !(array_key_exists("apiKey", $options) || array_key_exists("a", $options)) ||
    !(array_key_exists("seriesId", $options) || array_key_exists("s", $options))) {
  help();
}

$apiKey = (array_key_exists("apiKey", $options) ? $options['apiKey'] : $options['a']);
$seriesId = (array_key_exists("seriesId", $options) ? $options['seriesId'] : $options['s']);

$ret = retrieveSeriesById($apiKey, $seriesId);
if ($ret) {
  $episodes = parseEpisodeXml('en.xml');
  foreach ($episodes as $episode) {
    print sprintf("INSERT INTO tv2_episode (id, tvdb_seriesId, firstAired, season, episode, episode_title) VALUES (%s, %s, '%s', %s, %s, '%s');\n", 
      $episode['id'],
      $episode['seriesid'],
      $episode['FirstAired'],
      $episode['SeasonNumber'],
      $episode['EpisodeNumber'],
      addslashes($episode['EpisodeName']));
  }
}

return 0;

function help() {
  $filename = basename(__FILE__);
  print <<<EOT

Script downloads information about a given serie from http://www.thetvdb.com.
The downloaded ZIP file is extracted and the XML file parsed in order to
retrieve the episodes from the serie.

$filename [options]

options:
  -a <tvDbAPIKey>             API key for accessing thetvdb.com content
  --apiKey <tvDbAPIKey>
  -s <seriesId>               Id of the serie as integer
  --seriesId <seriesId>
  -h                          (optional) This page
  --help

EOT;

  exit;
}

?>