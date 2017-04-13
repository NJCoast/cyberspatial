FROM python:2.7

ENV PYTHONUNBUFFERED 1

# Setup Debian linux
RUN export DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y install build-essential curl


# Requirements have to be pulled and installed here, otherwise caching won't work
COPY ./requirements /requirements

RUN mkdir /app

# Main work directory will be app
WORKDIR /app
COPY . /app

RUN pip install -r /requirements/local.txt


COPY ./docker_compose/django/development/start.sh /start.sh
COPY ./docker_compose/django/entrypoint.sh /entrypoint.sh
RUN sed -i 's/\r//' /entrypoint.sh \
    && sed -i 's/\r//' /start.sh \
    && chmod +x /entrypoint.sh \
    && chmod +x /start.sh

ENTRYPOINT ["/entrypoint.sh"]
