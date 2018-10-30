#########
#
#     Dockerfile for Metagenomics Bioinformtics QC session
#
### To run the container for the first time with generic graphics:
# xhost +
# docker run -it -v /tmp/.X11-unix:/tmp/.X11-unix:rw --privileged -e DISPLAY=unix$DISPLAY \
# -v $HOME/:/home/training/ --device /dev/dri --privileged --name metagenomicsqc \
# ebitraining/metagenomics:qc
#
### To run with Nvidia graphics, add the following option:
# "-v /usr/lib/nvidia-340:/usr/lib/nvidia-340 -v /usr/lib32/nvidia-340:/usr/lib32/nvidia-340"
#
### To resume using an container:
# docker exec -it metagenomicsqc /bin/bash
#
### To build the container:
# docker build -f ./Dockerfile -t metagenomicsqc .
# docker tag metagenomicsqc ebitraining/metagenomics:qc
# docker push ebitraining/metagenomics:qc
#
#########
FROM ubuntu:18.04
LABEL author="Mohamed Alibi" \
description="Docker image for Metagenomics Bioinformtics QC session." \
maintainer="Mohamed Alibi <alibi@ebi.ac.uk>"

## Pre requirements
########
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL en_GB.UTF-8
ENV LANG en_GB.UTF-8
ENV LANGUAGE en_GB:en
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get install -y --reinstall language-pack-en \
    && apt-get install -y gnupg \
    && locale-gen en_GB.UTF-8

RUN apt-get update; apt-get install -y build-essential ca-certificates libbz2-dev liblzma-dev gfortran \
    libncurses5-dev libncursesw5-dev zlib1g-dev automake pkg-config unzip openjdk-8-jre-headless curl python-pip \
    git wget sudo autoconf make xml2 locales libjpeg-dev zlibc libjpeg62 libxslt1.1 nano openjdk-8-jre cpanminus \
    libxcomposite1 libtiff5 libssl-dev python3 python3-dev mesa-common-dev tar python-dev sudo mercurial \
    libcurses-ocaml-dev libgl1-mesa-dri libgl1-mesa-glx mesa-utils fcitx-frontend-qt5 libqt5gui5 openjfx \
    fcitx-modules fcitx-module-dbus libedit2 libxml2-dev default-jre default-jre-headless python sqlite3 \
    && update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java \
    && echo "en_GB.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_GB.utf8 \
    && /usr/sbin/update-locale LANG=en_GB.UTF-8

## Install packages available on default OS repo
########
RUN apt update && apt install -y bwa fastqc prodigal \
    && pip install -U numpy bcbio-gff cython scipy biopython pandas scikit-learn checkm-genome \
    && rm -rf /var/lib/apt/lists/* \
    && apt -y autoremove && apt autoclean && rm -rf /var/lib/apt/lists/*

# Install Perl packages using cpan
########
RUN cpanm install Data::Dumper Getopt::Long Pod::Usage File::Path Cwd FindBin

## Install Trimmomatic
########
ADD http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.38.zip /usr/local/Trimmomatic-0.38.zip
RUN unzip /usr/local/Trimmomatic-0.38.zip -d /usr/local/ \
    && echo -e '#!/bin/bash \n\njava -jar /usr/local/Trimmomatic-0.38/trimmomatic-0.38.jar $@' > /usr/local/Trimmomatic-0.38/trimmomatic \
    && chmod -R 777 /usr/local/Trimmomatic-0.38/ \
    && ln -s /usr/local/Trimmomatic-0.38/trimmomatic* /usr/local/bin/ \
    && rm /usr/local/Trimmomatic-0.38.zip

## Setup DeconSeq
########
COPY ./deconseq-standalone-0.4.3.tar.gz /usr/local/deconseq-standalone-0.4.3.tar.gz
COPY ./deconseq-graphs-0.1.tar.gz /usr/local/deconseq-graphs-0.1.tar.gz
RUN tar xvf /usr/local/deconseq-standalone-0.4.3.tar.gz -C /usr/local/ \
    && tar xvf /usr/local/deconseq-graphs-0.1.tar.gz -C /usr/local/
COPY ./DeconSeqConfig.pm /usr/local/deconseq-standalone-0.4.3/DeconSeqConfig.pm
RUN ln -s /usr/local/deconseq-standalone-0.4.3/*.pl /usr/local/bin/ \
    && ln -s /usr/local/deconseq-graphs-0.1/deconseq-graphs.pl /usr/local/bin/ \
    && chmod 777 -R /usr/local/deconseq* \
    && rm /usr/local/deconseq-graphs-0.1.tar.gz \
    && rm /usr/local/deconseq-standalone-0.4.3.tar.gz

## Install FastQC
########
ADD https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.8.zip /usr/local/fastqc.zip
RUN unzip /usr/local/fastqc.zip -d /usr/local/ \
    && chmod -R 777 /usr/local/FastQC \
    && ln -s /usr/local/FastQC/fastqc /usr/local/bin/ \
    && rm /usr/local/fastqc.zip

## Install Krona plots
########
ADD https://github.com/marbl/Krona/releases/download/v2.7/KronaTools-2.7.tar /usr/local/KronaTools.tar
RUN tar xvf /usr/local/KronaTools.tar -C /usr/local/ \
    && chmod 777 -R /usr/local/KronaTools-2.7 \
    && cd /usr/local/KronaTools-2.7 \
    && ./install.pl \
    && rm /usr/local/KronaTools.tar

## Create user training
########
RUN mkdir /home/training \
    &&  useradd --create-home --home-dir /home/training training

# Setup the user envirenment
########
ENV HOME /home/training
RUN chown -R training:training $HOME \
    && usermod -aG sudo,audio,video training \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

WORKDIR $HOME
USER training
