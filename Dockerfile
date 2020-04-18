FROM ubuntu:18.04

ARG UID
ENV UID ${UID:-1000}
ARG GID
ENV GID ${GROUP:-1000}

WORKDIR /steam

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo steam steam/question select "I AGREE" | debconf-set-selections \
 && echo steam steam/license note '' | debconf-set-selections

ARG DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386 \
 && apt-get update -y \
 && apt-get install -y --no-install-recommends ca-certificates locales steamcmd lib32tinfo5 \
 && rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8
ENV LANG 'en_US.UTF-8'
ENV LANGUAGE 'en_US:en'

RUN ln -s /usr/games/steamcmd /usr/bin/steamcmd

# RUN steamcmd +login anonymous +force_install_dir /steam/gmod +app_update 4020 validate +quit

RUN groupadd --gid ${GID} steam && \
    useradd -m --gid ${GID} --uid ${UID} steam && \
    chown -R ${UID}:${GID} /steam

USER ${UID}:${GID}

RUN steamcmd +quit

ARG DEBIAN_FRONTEND=

ENTRYPOINT ["steamcmd"]
CMD ["+help", "+quit"]
