# Run FastQC in a container
#
# Run on generic graphics
#
# docker run -it --rm -v /tmp/.X11-unix:/tmp/.X11-unix:rw --privileged -e DISPLAY=unix$DISPLAY -v $HOME/:/home/training/ --device /dev/dri --privileged --name fastqc ebitraining/fastqc:alpha
#
# Run on Nvidia graphics
#
# docker run -it --rm -v /tmp/.X11-unix:/tmp/.X11-unix:rw --privileged -e DISPLAY=unix$DISPLAY -v $HOME/:/home/training/ -v /usr/lib/nvidia-340:/usr/lib/nvidia-340 -v /usr/lib32/nvidia-340:/usr/lib32/nvidia-340 --device /dev/dri --privileged --name fastqc ebitraining/fastqc:alpha 
#
# USAGE:
#	# Build cytoscape image
#	docker build -f ./Dockerfile -t fastqc .
#

FROM openjdk:8
LABEL maintainer "Mohamed Alibi <alibimohamed@gmail.com>"

ADD https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.7.zip /usr/local/fastqc.zip

# Install dependencies
RUN apt-get update && apt-get install -y \
	unzip \
	libgl1-mesa-dri \
	libgl1-mesa-glx \
	mesa-utils \
	libgl1-mesa-glx \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

# Extract fastqc and set permisttions
RUN unzip /usr/local/fastqc.zip -d /usr/local/ \
	&& chmod -R 777 /usr/local/FastQC

# Create Symlink for fastqc
RUN ln -s /usr/local/FastQC/fastqc /usr/bin/fastqc

# nvidia-docker hooks
LABEL com.nvidia.volumes.needed="nvidia_driver"
ENV PATH /usr/lib/nvidia-340/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/lib/nvidia-340:/usr/lib32/nvidia-340:${LD_LIBRARY_PATH}

ENV HOME /home/training

RUN useradd --create-home --home-dir $HOME training \
	&& chown -R training:training $HOME \
	&& usermod -a -G audio,video training

WORKDIR $HOME
USER training

# Autorun FastQC
ENTRYPOINT [ "fastqc" ]
