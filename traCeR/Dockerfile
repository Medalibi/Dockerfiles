# TraCeR - reconstruction of T cell receptor sequences from single-cell RNA-seq data.
#
#
# docker run -it --rm -v /tmp/.X11-unix:/tmp/.X11-unix:rw --privileged -e DISPLAY=unix$DISPLAY -v $HOME/:/home/training/ --device /dev/dri --privileged --name TraCeR ebitraining/TraCeR:latest /bin/bash
#
# docker run --rm -it -v $HOME/:/home/training/ --device /dev/dri --privileged --name TraCeR ebitraining/TraCeR:latest /bin/bash
#
#

FROM ubuntu:16.04

LABEL author="Mohamed Alibi" \
description="TraCeR: Reconstruction of T cell receptor sequences from single-cell RNA-seq data." \
maintainer="Mohamed Alibi <alibimohamed@gmail.com>"

# Download TraCeR and Pre-requisites
ADD https://downloads.sourceforge.net/project/bowtie-bio/bowtie/1.2.2/bowtie-1.2.2-linux-x86_64.zip /usr/local/bowtie.zip
ADD https://downloads.sourceforge.net/project/bowtie-bio/bowtie2/2.3.4.1/bowtie2-2.3.4.1-linux-x86_64.zip /usr/local/bowtie2.zip
ADD https://github.com/COMBINE-lab/salmon/releases/download/v0.9.1/Salmon-0.9.1_linux_x86_64.tar.gz /usr/local/Salmon.tar.gz
ADD https://github.com/pachterlab/kallisto/releases/download/v0.44.0/kallisto_linux-v0.44.0.tar.gz /usr/local/kallisto.tar.gz
ADD https://github.com/trinityrnaseq/trinityrnaseq/releases/download/Trinity-v2.6.6/Trinityrnaseq-v2.6.6.wExtSampleData.tar.gz /usr/local/Trinityrnaseq.tar.gz
COPY ncbi-igblast-1.9.0-x64-linux.tar.gz /usr/local/igblast.tar.gz

# Install libraries
RUN apt-get update && apt-get install -y --no-install-recommends \
	build-essential ca-certificates git python-dev python-pip \
	graphviz graphviz-dev jellyfish libjellyfish-2.0-dev \
	libjellyfish-2.0-2 zlib1g-dev unzip rsync apt-utils \
	&& rm -rf /var/lib/apt/lists/*

# Install bowtie
RUN unzip /usr/local/bowtie.zip -d /usr/local/ \
	&& chmod 777 -R /usr/local/bowtie-1.2.2-linux-x86_64 \
	&& ln -s /usr/local/bowtie-1.2.2-linux-x86_64/bowtie* /usr/local/bin/ \
	&& rm /usr/local/bowtie.zip

# Install bowtie2
RUN unzip /usr/local/bowtie2.zip -d /usr/local/ \
        && chmod 777 -R /usr/local/bowtie2-2.3.4.1-linux-x86_64 \
        && ln -s /usr/local/bowtie2-2.3.4.1-linux-x86_64/bowtie2* /usr/local/bin/ \
        && rm /usr/local/bowtie2.zip

# Install Salmon
RUN tar xvf /usr/local/Salmon.tar.gz -C /usr/local/ \
        && chmod 777 -R /usr/local/Salmon-latest_linux_x86_64 \
        && ln -s /usr/local/Salmon-latest_linux_x86_64/bin/salmon /usr/local/bin/ \
        && rm /usr/local/Salmon.tar.gz

# Install kallisto
RUN tar xvf /usr/local/kallisto.tar.gz -C /usr/local/ \
        && chmod 777 -R /usr/local/kallisto_linux-v0.44.0 \
        && ln -s /usr/local/kallisto_linux-v0.44.0/kallisto /usr/local/bin/ \
        && rm /usr/local/kallisto.tar.gz

# Install Trinity
RUN tar xvf /usr/local/Trinityrnaseq.tar.gz -C /usr/local/ \
        && chmod 777 -R /usr/local/Trinityrnaseq-v2.6.6 \
	&& cd /usr/local/Trinityrnaseq-v2.6.6 \
	&& make \
	&& make install \
	&& ln -s /usr/local/Trinityrnaseq-v2.6.6/Trinity /usr/local/bin/ \
	&& rm /usr/local/Trinityrnaseq.tar.gz

# Install Igblast
RUN tar xvf /usr/local/igblast.tar.gz -C /usr/local/ \
        && chmod 777 -R /usr/local/ncbi-igblast-1.9.0 \
	&& ln -s /usr/local/ncbi-igblast-1.9.0/bin/* /usr/local/bin/ \
	&& rm /usr/local/igblast.tar.gz

# Install TraCeR
RUN cd /usr/local/ \
	&& git clone https://github.com/Teichlab/tracer.git \
	&& cd tracer/ \
	&& pip install setuptools --upgrade \
	&& pip install --upgrade pip==9.0.3 \
	&& pip install -r requirements.txt \
	&& python setup.py install \
	&& chmod 777 -R /usr/local/tracer

# Setup the user envirenment
ENV HOME /home/training

RUN useradd --create-home --home-dir $HOME training \
	&& chown -R training:training $HOME \
	&& usermod -a -G audio,video training

WORKDIR $HOME
USER training
