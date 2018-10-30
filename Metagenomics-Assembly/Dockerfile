#########
#
#     Dockerfile for Metagenomics Bioinformtics Assembly session
#
### To run the container for the first time with generic graphics:
# xhost +
# docker run -it -v /tmp/.X11-unix:/tmp/.X11-unix:rw --privileged -e DISPLAY=unix$DISPLAY \
# -v $HOME/:/home/training/ --device /dev/dri --privileged --name metagenomics \
# ebitraining/metagenomics:assembly
#
### To run with Nvidia graphics, add the following option:
# "-v /usr/lib/nvidia-340:/usr/lib/nvidia-340 -v /usr/lib32/nvidia-340:/usr/lib32/nvidia-340"
#
### To resume using an container:
# docker exec -it metagenomics /bin/bash
#
### To build the container:
# docker build -f ./Dockerfile -t metagenomics .
# docker tag metagenomics ebitraining/metagenomics:assembly
# docker push ebitraining/metagenomics:assembly
#
#########
FROM ubuntu:18.04
LABEL author="Mohamed Alibi" \
description="Docker image for Metagenomics Bioinformtics Assembly session." \
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
    libncurses5-dev libncursesw5-dev zlib1g-dev automake pkg-config unzip openjdk-8-jre-headless curl \
    git wget sudo autoconf make xml2 locales libjpeg-dev zlibc libjpeg62 libxslt1.1 nano openjdk-8-jre \
    libxcomposite1 libtiff5 libssl-dev python3 python3-dev mesa-common-dev tar python-dev sudo mercurial \
    libcurses-ocaml-dev libgl1-mesa-dri libgl1-mesa-glx mesa-utils fcitx-frontend-qt5 libqt5gui5 openjfx \
    fcitx-modules fcitx-module-dbus libedit2 libxml2-dev default-jre default-jre-headless python sqlite3 \
    python3-pip python-pip libgsl-dev \
    && update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java \
    && echo "en_GB.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_GB.utf8 \
    && /usr/sbin/update-locale LANG=en_GB.UTF-8

## Install packages available on default OS repo
########
RUN apt update && apt install -y bwa prodigal \
    && pip install -U numpy bcbio-gff cython scipy biopython pandas scikit-learn checkm-genome \
    && rm -rf /var/lib/apt/lists/* \
    && apt -y autoremove && apt autoclean && rm -rf /var/lib/apt/lists/*

## Install htslib
########
ADD https://github.com/samtools/htslib/releases/download/1.9/htslib-1.9.tar.bz2 /usr/local/htslib.tar.bz2
RUN tar xvjf /usr/local/htslib.tar.bz2 -C /usr/local/ \
     && chmod 777 -R /usr/local/htslib-1.9 \
     && cd /usr/local/htslib-1.9 \
     && ./configure \
     && make \
     && make install \
     && rm /usr/local/htslib.tar.bz2

## Install bcftools
########
ADD https://github.com/samtools/bcftools/releases/download/1.9/bcftools-1.9.tar.bz2 /usr/local/bcftools.tar.bz2
RUN tar xvjf /usr/local/bcftools.tar.bz2 -C /usr/local/ \
     && chmod 777 -R /usr/local/bcftools-1.9 \
     && cd /usr/local/bcftools-1.9 \
     && ./configure \
     && make \
     && make install \
     && rm /usr/local/bcftools.tar.bz2

## Install samtools
########
ADD https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2 /usr/local/samtools.tar.bz2
RUN tar xvjf /usr/local/samtools.tar.bz2 -C /usr/local/ \
     && chmod 777 -R /usr/local/samtools-1.9 \
     && cd /usr/local/samtools-1.9 \
     && ./configure \
     && make \
     && make install \
     && rm /usr/local/samtools.tar.bz2

## Install Metabat
########
ADD https://bitbucket.org/berkeleylab/metabat/downloads/metabat-static-binary-linux-x64_v2.12.1.tar.gz /usr/local/metabat-static-binary-linux-x64_v2.12.1.tar.gz
RUN tar xvf /usr/local/metabat-static-binary-linux-x64_v2.12.1.tar.gz -C /usr/local/ \
    && chmod 777 -R /usr/local/metabat \
    && /usr/local/metabat/contigOverlaps \
    && ln -s /usr/local/metabat/metabat* /usr/local/bin/ \
    && ln -s /usr/local/metabat/runMetaBat.sh /usr/local/bin/ \
    && ln -s /usr/local/metabat/*.pl /usr/local/bin/ \
    && rm /usr/local/metabat-static-binary-linux-x64_v2.12.1.tar.gz

## Install SPAdes
########
ADD http://cab.spbu.ru/files/release3.13.0/SPAdes-3.13.0-Linux.tar.gz /usr/local/SPAdes-3.13.0-Linux.tar.gz
RUN tar xvf /usr/local/SPAdes-3.13.0-Linux.tar.gz -C /usr/local/ \
    && chmod 777 -R /usr/local/SPAdes-3.13.0-Linux \
    && ln -s /usr/local/SPAdes-3.13.0-Linux/bin/* /usr/local/bin/ \
    && rm /usr/local/SPAdes-3.13.0-Linux.tar.gz

## Install Newick
########
ADD http://cegg.unige.ch/pub/newick-utils-1.6-Linux-x86_64-enabled-extra.tar.gz /usr/local/newick-utils-1.6-Linux-x86_64-enabled-extra.tar.gz
RUN tar xvf /usr/local/newick-utils-1.6-Linux-x86_64-enabled-extra.tar.gz -C /usr/local/ \
    && chmod 777 -R /usr/local/newick-utils-1.6 \
    && cd /usr/local/newick-utils-1.6 \
    && ./configure \
    && make \
    && make install \
    && ln -s /usr/local/newick-utils-1.6/src/nw_* /usr/local/bin/; exit 0 \
    && rm /usr/local/newick-utils-1.6-Linux-x86_64-enabled-extra.tar.gz

## Install Newick
########
ADD http://eddylab.org/software/hmmer/hmmer-3.2.tar.gz /usr/local/hmmer-3.2.tar.gz
RUN tar xvf /usr/local/hmmer-3.2.tar.gz -C /usr/local/ \
    && chmod 777 -R /usr/local/hmmer-3.2 \
    && cd /usr/local/hmmer-3.2 \
    && ./configure \
    && make \
    && make check \
    && make install \
    && cd easel \
    && make install \
    && rm /usr/local/hmmer-3.2.tar.gz

## Install PPlacer
########
ADD https://github.com/matsen/pplacer/releases/download/v1.1.alpha19/pplacer-linux-v1.1.alpha19.zip /usr/local/pplacer-linux-v1.1.alpha19.zip
RUN unzip /usr/local/pplacer-linux-v1.1.alpha19.zip -d /usr/local/ \
    && chmod -R 777 /usr/local/pplacer-Linux-v1.1.alpha19 \
    && ln -s /usr/local/pplacer-Linux-v1.1.alpha19/guppy /usr/local/bin/ \
    && ln -s /usr/local/pplacer-Linux-v1.1.alpha19/pplacer /usr/local/bin/ \
    && ln -s /usr/local/pplacer-Linux-v1.1.alpha19/rppr /usr/local/bin/ \
    && rm /usr/local/pplacer-linux-v1.1.alpha19.zip

## Install Bedtools
ADD https://github.com/arq5x/bedtools2/releases/download/v2.27.1/bedtools-2.27.1.tar.gz /usr/local/bedtools-2.27.1.tar.gz
RUN tar xvf /usr/local/bedtools-2.27.1.tar.gz -C /usr/local/ \
    && chmod 777 -R /usr/local/bedtools2 \
    && cd /usr/local/bedtools2 \
    && make \
    && make install \
    && rm /usr/local/bedtools-2.27.1.tar.gz

## Install FigTree
########
COPY ./FigTree_v1.4.3.tgz /usr/local/FigTree_v1.4.3.tgz
RUN tar xvf /usr/local/FigTree_v1.4.3.tgz -C /usr/local/ \
    && chmod 777 -R /usr/local/FigTree_v1.4.3 \
    && sed -i 's/lib\/figtree.jar/\/usr\/local\/FigTree_v1.4.3\/lib\/figtree.jar/g' /usr/local/FigTree_v1.4.3/bin/figtree \
    && ln -s /usr/local/FigTree_v1.4.3/bin/figtree /usr/local/bin/ \
    && rm /usr/local/FigTree_v1.4.3.tgz

## Install Megahit
########
RUN git clone https://github.com/voutcn/megahit.git /usr/local/megahit \
    && cd /usr/local/megahit \
    && chmod 777 -R /usr/local/megahit/ \
    && make \
    && ln -s /usr/local/megahit/megahit /usr/local/bin/;

## Install Anvio
########
RUN git clone https://github.com/merenlab/anvio.git /usr/local/anvio \
    && cd /usr/local/anvio \
    && chmod 777 -R /usr/local/anvio/ \
    && pip3 install -r requirements.txt \
    && pip3 install anvio

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
