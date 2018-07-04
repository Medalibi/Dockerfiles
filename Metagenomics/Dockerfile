#########
#     Dockerfile for Metagenomics Bioinformtics July 2018
#
## Run on generic graphics
#
# docker run -it --rm -v /tmp/.X11-unix:/tmp/.X11-unix:rw --privileged -e DISPLAY=unix$DISPLAY -v $HOME/:/home/training/ --device /dev/dri --privileged --name metagenomics ebitraining/metagenomics
#
# Run on Nvidia graphics
#
# docker run -it --rm -v /tmp/.X11-unix:/tmp/.X11-unix:rw --privileged -e DISPLAY=unix$DISPLAY -v $HOME/:/home/training/ -v /usr/lib/nvidia-340:/usr/lib/nvidia-340 -v /usr/lib32/nvidia-340:/usr/lib32/nvidia-340 --device /dev/dri --privileged --name metagenomics ebitraining/metagenomics
#
# USAGE:
#	# Build cytoscape image
#	docker build -f ./Dockerfile -t metagenomics .
#
#########
FROM ubuntu:16.04
LABEL author="Mohamed Alibi" \
description="Docker image for Metagenomics Bioinformtics July 2018 training course." \
maintainer="Mohamed Alibi <alibi@ebi.ac.uk>"

# Pre requirements
########
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL en_GB.UTF-8
ENV LANG en_GB.UTF-8
ENV LANGUAGE en_GB:en


ADD https://download1.rstudio.org/rstudio-xenial-1.1.453-amd64.deb /usr/local/rstudio-xenial-1.1.453-amd64.deb

RUN echo "deb http://cloud.r-project.org/bin/linux/ubuntu xenial-cran35/" >> /etc/apt/sources.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9

RUN apt update \
    && apt install -y --reinstall language-pack-en \
    && locale-gen en_US.UTF-8 \
    && apt -y upgrade

RUN apt install -y build-essential ca-certificates libbz2-dev liblzma-dev gfortran cmake \
    libncurses5-dev libncursesw5-dev libcurl4-openssl-dev libcurl3 zlib1g-dev python-dev \
    python-pip libblas-dev liblapack-dev automake pkg-config unzip nano git gem rubygems \
    seqtk metis libatlas-dev wget ruby mcl default-jre default-jdk sudo curl autoconf gcc \
    r-base r-base-core r-recommended gdebi make xml2 libjpeg-dev libpresage-data locales \
  	zlibc libjpeg62 littler libxslt1.1 libxcomposite1 libtiff5 libqt5widgets5 libqt5webkit5 \
    libcurses-ocaml-dev libgl1-mesa-dri libgl1-mesa-glx mesa-utils fcitx-frontend-qt5 \
  	fcitx-modules fcitx-module-dbus libedit2 libgstreamer0.10-0 libqt5core5a libqt5dbus5 \
  	libgstreamer-plugins-base0.10-0 libqt5gui5 libqt5network5 libqt5printsupport5 cpanminus \
    python3-dev python3-pip libssl-dev python3 mesa-common-dev libxml2-dev libcairo2-dev \
    libglu1-mesa-dev libx11-dev xorg libfreetype6-dev xvfb libgmp3-dev libtiff5-dev lua5.1 \
    liblua5.1-0-dev liblua5.3-dev liblua5.3-0 git-core zlib1g-dev libncurses-dev patch libgsl0-dev \
    && gdebi -n /usr/local/rstudio-xenial-1.1.453-amd64.deb \
    && echo "en_UK.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_UK.utf8 \
    && /usr/sbin/update-locale LANG=en_UK.UTF-8 \
    && apt-get install -fy \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /usr/local/*.deb \
    && ln -f -s /usr/lib/rstudio/bin/rstudio /usr/bin/rstudio \
    && apt -y autoremove && apt autoclean && rm -rf /var/lib/apt/lists/*

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

# Install Perl packages using cpan
########
RUN cpanm install Data::Dumper Getopt::Long Pod::Usage File::Path Cwd FindBin Cairo DeconSeqConfig

# Install Python packages using pip
########
RUN pip install -U pysam numpy bcbio-gff cython scipy biopython pandas pip scikit-learn checkm-genome
RUN pip3 install -U pysam numpy bcbio-gff cython scipy biopython pandas pip scikit-learn checkm-genome

# Install packages available on default repo
########
RUN apt install -y trimmomatic bowtie2 fastqc bwa hmmer parallel picard-tools bedtools mothur \
    prodigal velvet bedtools samtools libhts-dev

RUN Rscript --vanilla -e "source('https://bioconductor.org/biocLite.R'); biocLite(ask=FALSE); \
    biocLite(c('SIAMCAT', 'phyloseq', 'edgeR', 'phyloseq', 'ebimetagenomics', 'ALDEx2', 'ggplot2', \
    'optparse', 'pROC', 'colorRamps', 'RColorBrewer', 'beanplot', 'mlr', 'gridExtra', 'gplots', \
    'reshape', 'ggplot2', 'ellipse', 'getopt'), ask=FALSE);"

# Set default CRAN repo
########
RUN echo 'options(repos = c(CRAN = "https://cran.rstudio.com/"), download.file.method = "libcurl")' >> /etc/R/Rprofile.site \
    && echo 'source("/etc/R/Rprofile.site")' >> /etc/littler.r \
    && ln -s /usr/share/doc/littler/examples/install.r /usr/local/bin/install.r \
    && ln -s /usr/share/doc/littler/examples/install2.r /usr/local/bin/install2.r \
    && ln -s /usr/share/doc/littler/examples/installGithub.r /usr/local/bin/installGithub.r \
    && ln -s /usr/share/doc/littler/examples/testInstalled.r /usr/local/bin/testInstalled.r \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
    && echo '"\e[5~": history-search-backward' >> /etc/inputrc \
    && echo '"\e[6~": history-search-backward' >> /etc/inputrc \
    && chmod 777 -R /usr/local/lib/R/ \
    && chmod 777 -R /usr/lib/R/ \
    && chmod 777 -R /usr/share/R/

# Setup DeconSeq
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

# Setup MapSeq
########
ADD https://github.com/jfmrod/MAPseq/releases/download/v1.2.2/mapseq-1.2.2-linux.tar.gz /usr/local/mapseq-1.2.2-linux.tar.gz
RUN tar xvf /usr/local/mapseq-1.2.2-linux.tar.gz -C /usr/local/ \
    && chmod 777 -R /usr/local/mapseq-1.2.2-linux \
    && ln -s /usr/local/mapseq-1.2.2-linux/mapseq /usr/local/bin/ \
    && rm /usr/local/mapseq-1.2.2-linux.tar.gz

# Setup Anaconda
########
ADD https://repo.anaconda.com/archive/Anaconda2-5.2.0-Linux-x86_64.sh /usr/local/Anaconda2-5.2.0-Linux-x86_64.sh
RUN chmod 777 /usr/local/Anaconda2-5.2.0-Linux-x86_64.sh \
    && /usr/local/Anaconda2-5.2.0-Linux-x86_64.sh -b -p /usr/local/anaconda2 \
    && ln -s /usr/local/anaconda2/bin/* /usr/local/bin/ \
    && chmod 777 -R /usr/local/anaconda2/ \
    && rm /usr/local/Anaconda2-5.2.0-Linux-x86_64.sh

# Install Python packages on the conda envirenemnt
########
RUN pip install -U pysam numpy bcbio-gff cython scipy biopython pandas pip scikit-learn checkm-genome
RUN pip3 install -U pysam numpy bcbio-gff cython scipy biopython pandas pip scikit-learn checkm-genome

RUN conda create -n concoct_env python=2.7.6 \
    && source activate concoct_env \
    && conda install pysam numpy bcbio-gff cython numpy scipy biopython pandas pip scikit-learn

# Install Megan6 Community
########
ADD http://ab.inf.uni-tuebingen.de/data/software/megan6/download/MEGAN_Community_unix_6_12_0.sh /usr/local/MEGAN_Community_unix_6_12_0.sh
RUN chmod 777 /usr/local/MEGAN_Community_unix_6_12_0.sh \
    && /usr/local/MEGAN_Community_unix_6_12_0.sh -q -dir /usr/local/Megan6 \
    && ln -s /usr/local/megan6/MEGAN /usr/local/bin/ \
    && chmod 777 -R /usr/local/megan6/ \
    && rm /usr/local/MEGAN_Community_unix_6_12_0.sh

# Install Metabat
########
ADD https://bitbucket.org/berkeleylab/metabat/downloads/metabat-static-binary-linux-x64_v2.12.1.tar.gz /usr/local/metabat-static-binary-linux-x64_v2.12.1.tar.gz
RUN tar xvf /usr/local/metabat-static-binary-linux-x64_v2.12.1.tar.gz -C /usr/local/ \
    && chmod 777 -R /usr/local/metabat \
    && /usr/local/metabat/contigOverlaps \
    && ln -s /usr/local/metabat/metabat* /usr/local/bin/ \
    && ln -s /usr/local/metabat/runMetaBat.sh /usr/local/bin/ \
    && ln -s /usr/local/metabat/*.pl /usr/local/bin/ \
    && rm /usr/local/metabat-static-binary-linux-x64_v2.12.1.tar.gz

# Install SPAdes
########
ADD http://cab.spbu.ru/files/release3.12.0/SPAdes-3.12.0-Linux.tar.gz /usr/local/SPAdes-3.12.0-Linux.tar.gz
RUN tar xvf /usr/local/SPAdes-3.12.0-Linux.tar.gz -C /usr/local/ \
    && chmod 777 -R /usr/local/SPAdes-3.12.0-Linux \
    && ln -s /usr/local/SPAdes-3.12.0-Linux/bin/* /usr/local/bin/ \
    && rm /usr/local/SPAdes-3.12.0-Linux.tar.gz

# Install MaxBin
########
COPY ./MaxBin-2.2.5.tar.gz /usr/local/MaxBin-2.2.5.tar.gz
RUN tar xvf /usr/local/MaxBin-2.2.5.tar.gz -C /usr/local/ \
    && chmod 777 -R /usr/local/MaxBin-2.2.5 \
    && /usr/local/MaxBin-2.2.5/run_MaxBin.pl \
    && /usr/local/MaxBin-2.2.5/autobuild_auxiliary \
    && ln -s /usr/local/MaxBin-2.2.5/src/MaxBin /usr/local/bin/ \
    && rm /usr/local/MaxBin-2.2.5.tar.gz

# Install Newick
########
ADD http://cegg.unige.ch/pub/newick-utils-1.6-Linux-x86_64-enabled-extra.tar.gz /usr/local/newick-utils-1.6-Linux-x86_64-enabled-extra.tar.gz
RUN tar xvf /usr/local/newick-utils-1.6-Linux-x86_64-enabled-extra.tar.gz -C /usr/local/ \
    && chmod 777 -R /usr/local/newick-utils-1.6 \
    && cd /usr/local/newick-utils-1.6 \
    && ./configure \
    && make \
    && make install \
    && ln -s /usr/local/newick-utils-1.6/src/nw_* /usr/local/bin/ \
    && rm /usr/local/newick-utils-1.6-Linux-x86_64-enabled-extra.tar.gz

# Install PPlacer
########
ADD https://github.com/matsen/pplacer/releases/download/v1.1.alpha19/pplacer-linux-v1.1.alpha19.zip /usr/local/pplacer-linux-v1.1.alpha19.zip
RUN unzip /usr/local/pplacer-linux-v1.1.alpha19.zip -d /usr/local/ \
    && chmod -R 777 /usr/local/pplacer-Linux-v1.1.alpha19 \
    && /usr/local/pplacer-Linux-v1.1.alpha19/scripts/setup.py \
    && ln -s /usr/local/pplacer-Linux-v1.1.alpha19/guppy /usr/local/bin/ \
    && ln -s /usr/local/pplacer-Linux-v1.1.alpha19/pplacer /usr/local/bin/ \
    && ln -s /usr/local/pplacer-Linux-v1.1.alpha19/rppr /usr/local/bin/ \
    && rm /usr/local/pplacer-linux-v1.1.alpha19.zip

# Install Blast+
########
ADD https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.7.1/ncbi-blast-2.7.1+-x64-linux.tar.gz /usr/local/ncbi-blast-2.7.1+-x64-linux.tar.gz
RUN tar xvf /usr/local/ncbi-blast-2.7.1+-x64-linux.tar.gz -C /usr/local/ \
    && chmod 777 -R /usr/local/ncbi-blast-2.7.1+ \
    && ln -s /usr/local/ncbi-blast-2.7.1+/bin/* /usr/local/bin/ \
    && rm /usr/local/ncbi-blast-2.7.1+-x64-linux.tar.gz

# Install CONCOCT
########
ADD https://github.com/BinPro/CONCOCT/archive/0.4.0.tar.gz /usr/local/0.4.0.tar.gz
RUN tar xvf /usr/local/0.4.0.tar.gz -C /usr/local/ \
    && chmod 777 -R /usr/local/CONCOCT-0.4.0 \
    && cd /usr/local/CONCOCT-0.4.0 \
    && conda create -n concoct_env python=2.7.6 \
    && source activate concoct_env \
    && conda install cython numpy scipy biopython pandas pip scikit-learn \
    && python setup.py install \
    && rm /usr/local/0.4.0.tar.gz

# Install DESMAN
########
RUN git clone https://github.com/chrisquince/DESMAN.git /usr/local/DESMAN \
    && cd /usr/local/DESMAN \
    && chmod 777 -R /usr/local/DESMAN \
    && python3 ./setup.py install

# Install Bam_readcount
########
RUN git clone https://github.com/genome/bam-readcount.git /usr/local/bam-readcount \
    && cd /usr/local/bam-readcount \
    && chmod 777 -R /usr/local/bam-readcount \
    && cmake ./ \
    && make \
    && make install

# Install Diamand
########
RUN git clone https://github.com/bbuchfink/diamond.git /usr/local/diamond \
    && cd /usr/local/diamond \
    && chmod 777 -R /usr/local/diamond/ \
    && make \
    && ln -s /usr/local/diamond/diamond /usr/local/bin/

# Copy datasets
########
COPY ./QC_session /dataset/QC_session
RUN chmod 777 -R /dataset/

# Create user training
########
RUN useradd --create-home --home-dir /home/training training \
    && mkdir /home/training \
    && chown -R training:training /home/training

# Setup the user envirenment
########
ENV HOME /home/training
RUN && chown -R training:training /home/training \
    && usermod -a -G audio,video training \
    && adduser training sudo \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

WORKDIR $HOME
USER training
