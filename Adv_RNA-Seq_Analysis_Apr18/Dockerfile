###
#  Matthew MacManes requirements for Advanced RNA-Seq Analysis April 2018
#  Last update: 22/03/2018
#
###
FROM ubuntu:16.04
MAINTAINER Mohamed Alibi (alibi@ebi.ac.uk)

# Pre requirements
########
RUN apt update && apt -y upgrade
RUN apt install -y build-essential ca-certificates libbz2-dev liblzma-dev gfortran cmake \
    libncurses5-dev libncursesw5-dev libcurl4-openssl-dev libcurl3 zlib1g-dev python-dev \
    python-pip libblas-dev liblapack-dev automake pkg-config unzip nano git gem rubygems \
    seqtk metis libatlas-dev wget ruby mcl default-jre default-jdk sudo curl \
    && apt-get autoclean && rm -rf /var/lib/apt/lists/*

# Download tools archives
########
ADD https://github.com/samtools/htslib/releases/download/1.7/htslib-1.7.tar.bz2 /usr/local/htslib-1.7.tar.bz2
ADD https://github.com/samtools/samtools/releases/download/1.7/samtools-1.7.tar.bz2 /usr/local/samtools-1.7.tar.bz2
ADD http://salmon-tddft.jp/download/SALMON-v.1.0.0.tar.gz /usr/local/SALMON-v.1.0.0.tar.gz
ADD http://spades.bioinf.spbau.ru/release3.11.1/SPAdes-3.11.1-Linux.tar.gz /usr/local/SPAdes-3.11.1-Linux.tar.gz
ADD https://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.3.4.1/bowtie2-2.3.4.1-linux-x86_64.zip /usr/local/bowtie2-2.3.4.1-linux-x86_64.zip
ADD ftp://ftp.genome.umd.edu/pub/jellyfish/jellyfish-2.2.0.tar.gz  /usr/local/jellyfish-2.2.0.tar.gz
ADD ftp://ftp.genome.umd.edu/pub/quorum/quorum-1.0.0.tar.gz /usr/local/quorum-1.0.0.tar.gz
ADD https://github.com/trinityrnaseq/trinityrnaseq/releases/download/Trinity-v2.6.6/Trinityrnaseq-v2.6.6.wExtSampleData.tar.gz /usr/local/Trinityrnaseq-v2.6.6.wExtSampleData.tar.gz
ADD http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.36.zip /usr/local/Trimmomatic-0.36.zip

# Install htslib
########
RUN tar xvf /usr/local/htslib-1.7.tar.bz2 -C /usr/local/
WORKDIR /usr/local/htslib-1.7
RUN ./configure \
    && make \
    && make install \
    && rm /usr/local/htslib-1.7.tar.bz2

# Install samtools
RUN tar xvf /usr/local/samtools-1.7.tar.bz2 -C /usr/local/
WORKDIR /usr/local/samtools-1.7
RUN ./configure \
    && make \
    && make install \
    && rm /usr/local/samtools-1.7.tar.bz2

# Install Translate
########
RUN gem install translate \
    && translate --install-deps all

# Install Salamon
########
RUN tar xvf /usr/local/SALMON-v.1.0.0.tar.gz -C /usr/local
WORKDIR /usr/local/SALMON-v.1.0.0
RUN mkdir build && cd build \
    && python ../configure.py --prefix=../ \
    && make && make install \
    && ln -s /usr/local/SALMON-v.1.0.0/bin/salmon.cpu /usr/local/bin/ \
    && rm /usr/local/SALMON-v.1.0.0.tar.gz

# Install Busco
########
#WORKDIR /usr/local/
#RUN git clone https://gitlab.com/ezlab/busco.git \
#    && cd busco \
#    && python setup.py install \
#    && ln -s /usr/local/busco/scripts/* /usr/local/bin/

# Install Spades
########
RUN tar xvf /usr/local/SPAdes-3.11.1-Linux.tar.gz -C /usr/local \
    && ln -s /usr/local/SPAdes-3.11.1-Linux/bin/* /usr/local/bin/ \
    && ln -s /usr/local/SPAdes-3.11.1-Linux/spades /usr/local/share/ \
    && rm /usr/local/SPAdes-3.11.1-Linux.tar.gz

# Install Bowtie2
########
RUN unzip /usr/local/bowtie2-2.3.4.1-linux-x86_64.zip -d /usr/local/ \
    && ln -s /usr/local/bowtie2-2.3.4.1-linux-x86_64/bowtie2* /usr/local/bin/ \
    && rm /usr/local/bowtie2-2.3.4.1-linux-x86_64.zip

# Install Jellyfish 2.2.0
########
RUN tar xvf /usr/local/jellyfish-2.2.0.tar.gz -C /usr/local
WORKDIR /usr/local/jellyfish-2.2.0
RUN autoreconf -i \
    ./configure --enable-python-binding --enable-perl-binding \
    && make -j 4 \
    && make install \
    && ldconfig \
    && rm /usr/local/jellyfish-2.2.0.tar.gz

# Install Quorum
########
RUN tar xvf /usr/local/quorum-1.0.0.tar.gz -C /usr/local
WORKDIR /usr/local/quorum-1.0.0
RUN ./configure \
    && make \
    && make install \
    && rm /usr/local/quorum-1.0.0.tar.gz

# Install Shannon
########
WORKDIR /usr/local/
RUN pip install --upgrade pip \
    && pip install numpy cvxopt biopython scipy \
    && git clone https://github.com/sreeramkannan/Shannon.git \
    && ln -s /usr/local/Shannon/*.py /usr/local/bin/

# Install Trinityrnaseq
########
RUN tar xvf /usr/local/Trinityrnaseq-v2.6.6.wExtSampleData.tar.gz -C /usr/local
WORKDIR /usr/local/Trinityrnaseq-v2.6.6/
RUN make \
    && make plugins \
    && make install \
    && ln -s /usr/local/Trinityrnaseq-v2.6.6/Trinity /usr/local/bin/ \
    && rm /usr/local/Trinityrnaseq-v2.6.6.wExtSampleData.tar.gz
ENV TRINITY_HOME /usr/local/Trinityrnaseq-v2.6.6

# Install Rcorrector
########
WORKDIR /usr/local/
RUN git clone https://github.com/mourisl/rcorrector.git \
    && make \
    && ln -s /usr/local/rcorrector/r* /usr/local/bin/

# Install Trimmomatic
########
RUN /usr/local/Trimmomatic-0.36.zip -d /usr/local/ \
    && echo "#/bin/bash" > /usr/local/Trimmomatic-0.36/trimmomatic \
    && echo "cd /usr/local/Trimmomatic-0.36/" >> /usr/local/Trimmomatic-0.36/trimmomatic \
    && echo "java -jar /usr/local/Trimmomatic-0.36/trimmomatic-0.36.jar \"\$@\"" >> /usr/local/Trimmomatic-0.36/trimmomatic \
    && chmod +x -R /usr/local/Trimmomatic-0.36 \
    && ln -s /usr/local/Trimmomatic-0.36/trimmomatic* /usr/local/bin/ \
    && rm /usr/local/Trimmomatic-0.36.zip

# Create user training
########
RUN useradd --create-home --home-dir /home/training training \
    && mkdir /home/linuxbrew \
    && chown -R training:training /home/linuxbrew

# Install Miniconda
########
RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh && bash miniconda.sh -b -p /home/training/miniconda \
    && echo 'export PATH="/home/training/miniconda/bin:$PATH"' >> /home/training/.bashrc \


# Setup the user envirenment
########
ENV HOME /home/training
RUN && chown -R training:training /home/training \
    && usermod -a -G audio,video training \
    && adduser training sudo \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

WORKDIR $HOME
USER training

# Install Miniconda
########
RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh && bash miniconda.sh -b -p /home/training/miniconda \
    && echo 'export PATH="/home/training/miniconda/bin:$PATH"' >> /home/training/.bashrc

# Install Dammit
########
RUN source ~/.bashrc \
    && conda create -n dammit python=3 -y
RUN source activate dammit \
    && conda config --add channels defaults \
    && conda config --add channels conda-forge \
    && conda config --add channels bioconda \
    && conda install -y dammit
RUN  dammit databases
RUN  dammit databases --install
RUN  dammit databases --install --busco-group fungi

# Install Oyster River Protocol
########
RUN git clone https://github.com/Linuxbrew/brew.git /home/linuxbrew/.linuxbrew \
    && echo 'export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"' >> ~/.bashrc \
    && echo 'export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"' >> ~/.bashrc \
    && echo 'export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"' >> ~/.bashrc \
    && source ~/.bashrc \
    && brew tap brewsci/science \
    && brew tap brewsci/bio \
    && brew update \
    && brew install gcc python metis parallel \
    && pip install --upgrade pip \
    && pip install numpy cvxopt biopython scipy \
    && git clone https://github.com/macmanes-lab/Oyster_River_Protocol.git \
    && cd Oyster_River_Protocol \
    && make -j4 \
    && mkdir busco_dbs && cd busco_dbs \
    && wget http://busco.ezlab.org/v2/datasets/eukaryota_odb9.tar.gz \
    && wget http://busco.ezlab.org/v2/datasets/fungi_odb9.tar.gz \
    && wget http://busco.ezlab.org/v2/datasets/metazoa_odb9.tar.gz \
    && wget http://busco.ezlab.org/v2/datasets/nematoda_odb9.tar.gz \
    && wget http://busco.ezlab.org/v2/datasets/arthropoda_odb9.tar.gz \
    && wget http://busco.ezlab.org/v2/datasets/insecta_odb9.tar.gz \
    && wget http://busco.ezlab.org/v2/datasets/vertebrata_odb9.tar.gz \
    && wget http://busco.ezlab.org/v2/datasets/tetrapoda_odb9.tar.gz \
    && wget http://busco.ezlab.org/v2/datasets/aves_odb9.tar.gz \
    && wget http://busco.ezlab.org/v2/datasets/mammalia_odb9.tar.gz \
    && tar -zxf eukaryota_odb9.tar.gz \
    && cd /home/training \
    && mv /home/training/Oyster_River_Protocol/software/config.ini /home/training/Oyster_River_Protocol/software/busco/config/config.ini \
    && sed -r -i "s/mmacmane/training/g" /home/training/Oyster_River_Protocol/software/busco/config/config.ini \
    && sudo ln -s /home/training//Oyster_River_Protocol/software/orp-transrate/transrate /usr/local/bin/transrate \
    && sudo ln -s /home/training//Oyster_River_Protocol/software/busco/scripts/* /usr/local/bin/
