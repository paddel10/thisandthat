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
**/

/**
* @functionName     retrieveDailyUpdate
* @description      Retrieve series from the given id and store content
*                   to file dailyUpdate.xml
* @param            apiKey
* @return           true if daily upated was downloaded and stored
**/
function retrieveDailyUpdate($apiKey) {
  $patternUrl = "http://thetvdb.com/api/%s/updates/updates_day.xml";
  $updateUrl = sprintf($patternUrl, $apiKey);
  $updateXml = file_get_contents($updateUrl);
  file_put_contents("dailyUpdate.xml", $updateXml);
  return true;
}

function parseDailyUpdateXml($filename) {
  $data = simplexml_load_file($filename);
  $updates = array();
  foreach ($data->Series as $serie) {
    array_push($updates, (string)$serie->id);
  }
  return $updates;
}

/**
* @functionName     retrieveSeriesById
* @description      Retrieve series from the given id
* @param            apiKey
* @param            series id
* @return           true if series was downloaded
**/
function retrieveSeriesById($apiKey, $seriesId) {
  $ret = false;
  $patternUrl = "http://thetvdb.com/api/%s/series/%d/all/en.zip";
  $seriesUrl = sprintf($patternUrl, $apiKey, $seriesId);
  $zipdownload = file_get_contents($seriesUrl);
  $storedZip = sprintf("%s.zip", $seriesId);
  file_put_contents($storedZip, $zipdownload);
  
  $zip = new ZipArchive;
  $res = $zip->open($storedZip);
  if ($res === TRUE) {
    $zip->extractTo('.', 'en.xml');
    $zip->close();
    $ret = true;
  }
  unlink($storedZip);
  return $ret;
}

/**
* @functionName     parseEpisodeXml
* @description      parse xml file
* @param            name of the extracted xml file to parse
* @return           array of episodes
**/
function parseEpisodeXml($filename) {
  $data = simplexml_load_file($filename);
  $episodes = array();
  
  foreach ($data->Episode as $episode) {
    array_push($episodes, array(
      'seriesid' => (string)$episode->seriesid,
      'seasonid' => (string)$episode->seasonid,
      'id' => (string)$episode->id,
      'SeasonNumber' => (string)$episode->SeasonNumber,
      'EpisodeNumber' => (string)$episode->EpisodeNumber,
      'FirstAired' => (string)$episode->FirstAired,
      'EpisodeName' => (string)$episode->EpisodeName
    ));
  }
  return $episodes;
}
?>