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

$shortopts = "h";

$longopts = array(
  "help",
  "apiKey:",
  "seriesId:"
);

$options = getopt($shortopts, $longopts);

if (array_key_exists("help", $options) ||
    array_key_exists("h", $options) ||
    !array_key_exists("apiKey", $options) ||
    !array_key_exists("seriesId", $options)) {
  help();
}

$ret = retrieveSeriesById($options['apiKey'], $options['seriesId']);
if ($ret) {
  $episodes = parseEpisodeXml('en.xml');
  foreach ($episodes as $episode) {
    print sprintf("INSERT INTO tv2_episode (id, FirstAired, SeasonNumber, EpisodeNumber, EpisodeName, seriesId) VALUES (%s, '%s', %s, %s, '%s', %s);\n", $episode['id'], $episode['FirstAired'], $episode['SeasonNumber'], $episode['EpisodeNumber'], $episode['EpisodeName'], $episode['seriesid']);
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
  -apiKey <tvDbAPIKey>      API key for accessing thetvdb.com content
  -seriesId <seriesId>      Id of the serie as integer
  -h|help|?                 (optional) This page  
EOT;

  exit;
}

?>