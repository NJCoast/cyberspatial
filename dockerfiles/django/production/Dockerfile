FROM python:2.7

ENV PYTHONUNBUFFERED 1

# Setup Debian linux
RUN export DEBIAN_FRONTEND=noninteractive

# This section is borrowed from the official Django image but adds GDAL and others
RUN apt-get update && apt-get install -y \
		gcc \
		gettext \
		postgresql-client libpq-dev \
		sqlite3 \
    python-gdal python-psycopg2 \
    python-imaging python-lxml \
    python-dev libgdal-dev \
    python-ldap \
    libmemcached-dev libsasl2-dev zlib1g-dev \
    python-pylibmc \
    curl \
	--no-install-recommends && rm -rf /var/lib/apt/lists/*


# Upgrade pip
RUN pip install --upgrade pip

# python-gdal does not seem to work, let's install manually the version that is
# compatible with the provided libgdal-dev
RUN pip install GDAL==1.10 --global-option=build_ext --global-option="-I/usr/include/gdal"

# Requirements have to be pulled and installed here, otherwise caching won't work
COPY ./requirements /requirements

RUN mkdir /app

# Main work directory will be app
WORKDIR /app
COPY . /app

RUN pip install --no-cache-dir -r /requirements/production.txt --src /usr/local/src


COPY ./dockerfiles/django/production/start.sh /start.sh
COPY ./dockerfiles/django/entrypoint.sh /entrypoint.sh
RUN sed -i 's/\r//' /entrypoint.sh \
    && sed -i 's/\r//' /start.sh \
    && chmod +x /entrypoint.sh \
    && chmod +x /start.sh

ENTRYPOINT ["/entrypoint.sh"]
