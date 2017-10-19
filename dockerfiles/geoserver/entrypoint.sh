#!/usr/bin/env sh
set -e

if [ ! -f "/geoserver_data/data/.downloaded" ]; then
    rm -rf /geoserver_data/data/*

    # Download base data
    curl -L -O http://build.geonode.org/geoserver/latest/data-2.10.x.zip

    mkdir -p /tmp/geonode/downloaded
    unzip -x -d /tmp/geonode/downloaded data-2.10.x.zip

    # Move data to volume
    mkdir -p /geoserver_data
    cp -r /tmp/geonode/downloaded/data /geoserver_data

    # Touch file to not download again
    echo "2.10" > /geoserver_data/data/.downloaded
fi

if grep -q "2.9" /geoserver_data/data/.downloaded; then
    # Touch file to not download again
    echo "2.10" > /geoserver_data/data/.downloaded

    cd /geoserver_data/data

    # Download Patch
    curl -L -O https://raw.githubusercontent.com/NJCoast/geoserver-data-patch/master/0001-Migrate-from-2.9.x-to-2.10.x.patch

    # Apply Patch
    git apply -v --ignore-whitespace 0001-Migrate-from-2.9.x-to-2.10.x.patch
fi

cd /usr/local/tomcat/tmp

# Update
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
