#!/bin/bash
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
# -----------------------------------------------------------------------------
# Script is used for retrieving series information in a batch. It calls the
# perl script buildTvDb.pl. Series IDs are provided in a seperate file. Each
# line holds the ID of a serie. Lines starting with a pound (#) sign are skipped.

if [ "$#" -ne 2 ]; then
    echo "Illegal number of parameters - usage: $0 <API_KEY> <SERIES_ID_LIST_FILE>"
    exit -1
fi

API_KEY=$1
SERIES_ID_LIST_FILE=$2
HEADER="-header"

while read SERIES_ID
do
    if ! [[ "$SERIES_ID" =~ ^# ]]; then
        perl buildTvDb.pl -apiKey ${API_KEY} -seriesId ${SERIES_ID} ${HEADER}
        if [ $? -ne 0 ] ; then
            exit;
        fi
        HEADER=
    fi
done <${SERIES_ID_LIST_FILE}