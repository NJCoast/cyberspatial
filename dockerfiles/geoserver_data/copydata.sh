#!/usr/bin/env sh

# Shell script to copy dounloaded data directory to
# persistent data volume.

GEOSERVER_BASE_DATA_DIR=/geoserver_data
TEMP_DOWNLOADED=/tmp/geonode/downloaded


# preparing the volume
mkdir -p ${GEOSERVER_BASE_DATA_DIR}
cp -r ${TEMP_DOWNLOADED}/data ${GEOSERVER_BASE_DATA_DIR}
