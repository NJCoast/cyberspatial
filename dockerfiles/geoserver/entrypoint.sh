#!/usr/bin/env sh
set -e

if [ ! -f "/geoserver_data/data/.downloaded" ]; then
    rm -rf /geoserver_data/data/*

    # Download base data
    curl -L -O http://build.geonode.org/geoserver/latest/data-2.9.x-oauth2.zip

    mkdir -p /tmp/geonode/downloaded
    unzip -x -d /tmp/geonode/downloaded data-2.9.x-oauth2.zip

    # Move data to volume
    mkdir -p /geoserver_data
    cp -r /tmp/geonode/downloaded/data /geoserver_data

    # Touch file to not download again
    touch /geoserver_data/data/.downloaded
fi

# Update
echo sed -i "s|http://localhost:8000/|$DJANGO_URL|g" /geoserver_data/data/security/auth/geonodeAuthProvider/config.xml
sed -i "s|http://localhost:8000/|$DJANGO_URL|g" /geoserver_data/data/security/auth/geonodeAuthProvider/config.xml

echo sed -i "s|http://localhost:8000|$DJANGO_URL|g" /geoserver_data/data/security/role/geonode\ REST\ role\ service/config.xml
sed -i "s|http://localhost:8000|$DJANGO_URL|g" /geoserver_data/data/security/role/geonode\ REST\ role\ service/config.xml

echo sed -i "s|http://localhost:8000/|$DJANGO_URL|g" /geoserver_data/data/security/filter/geonode-oauth2/config.xml
sed -i "s|http://localhost:8000/|$DJANGO_URL|g" /geoserver_data/data/security/filter/geonode-oauth2/config.xml
echo sed -i "s|http://localhost:8080/geoserver|$GEOSERVER_PUBLIC_LOCATION|g" /geoserver_data/data/security/filter/geonode-oauth2/config.xml
sed -i "s|http://localhost:8080/geoserver|$GEOSERVER_PUBLIC_LOCATION|g" /geoserver_data/data/security/filter/geonode-oauth2/config.xml

echo sed -i "s|http://localhost:8080/geoserver|$GEOSERVER_PUBLIC_LOCATION|g" /geoserver_data/data/global.xml
sed -i "s|http://localhost:8080/geoserver|$GEOSERVER_PUBLIC_LOCATION|g" /geoserver_data/data/global.xml

# start tomcat
exec catalina.sh run
