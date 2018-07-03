# Run Pymol 2 Edu in a container
#
# Run on generic grafics
#
# docker run -it --rm -v /tmp/.X11-unix:/tmp/.X11-unix:rw --privileged -e DISPLAY=unix$DISPLAY -v $HOME/:/home/training/ --device /dev/dri --privileged --name pymol ebitraining/pymol:alpha /bin/bash
#
# Run on Nvidia graphics
#
# docker run -it --rm -v /tmp/.X11-unix:/tmp/.X11-unix:rw --privileged -e DISPLAY=unix$DISPLAY -v $HOME/:/home/training/ -v /usr/lib/nvidia-340:/usr/lib/nvidia-340 -v /usr/lib32/nvidia-340:/usr/lib32/nvidia-340 --device /dev/dri --privileged --name pymol ebitraining/pymol:alpha /bin/bash
#
# USAGE:
#	# Build cytoscape image
#	docker build -f ./Dockerfile -t pymol .
#

FROM ubuntu:16.04
LABEL maintainer "Mohamed Alibi <alibimohamed@gmail.com>"

COPY PyMOL-2.0.7_0-Linux-x86_64.tar.bz2 /usr/local/pymol.tar.bz2

# Install dependencies
RUN apt-get update && apt-get install -y \
	lbzip2 \
	build-essential \
	python-dev \
	python-pmw \
	libglew-dev \
	freeglut3-dev \
	libpng-dev \
	libfreetype6-dev \
	libxml2-dev \
	libgl1-mesa-dri \
	libgl1-mesa-glx \
	libgstreamer0.10-0 \
	libgstreamer-plugins-base0.10-0 \
	libjpeg-dev \
	libpresage-data \
	libqt5core5a \
	libqt5dbus5 \
	libqt5gui5 \
	libqt5network5 \
	libqt5printsupport5 \
	libqt5webkit5 \
	libqt5widgets5 \
	libtiff5 \
	libxcomposite1 \
	libxslt1.1 \
	ca-certificates \
	fcitx-frontend-qt5 \
	fcitx-modules \
	fcitx-module-dbus \
	libedit2 \
	xcb \
	apbs \
	blt \
	freeglut3 \
	libblas-common \
	libblas3 \
	libgfortran3 \
	liblapack3 \
	libmaloc1 \
	python-numpy \
	python-tk \
	tk8.6-blt2.5 \
	mesa-utils \
	libgl1-mesa-glx

# Extract Pymol 
RUN tar xvf /usr/local/pymol.tar.bz2 -C /usr/local/

# Create Symlink for Pymol
RUN ln -s /usr/local/pymol/bin/pymol /usr/bin/pymol

# Clean up the system
RUN apt-get purge -y --auto-remove lbzip2 \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -f /usr/local/pymol.tar.bz2

# nvidia-docker hooks
LABEL com.nvidia.volumes.needed="nvidia_driver"
ENV PATH /usr/lib/nvidia-340/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/lib/nvidia-340:/usr/lib32/nvidia-340:${LD_LIBRARY_PATH}


# Setup the user envirenment
ENV HOME /home/training

RUN useradd --create-home --home-dir $HOME training \
	&& chown -R training:training $HOME \
	&& usermod -a -G audio,video training

WORKDIR $HOME
USER training

# Autorun pymol
ENTRYPOINT [ "pymol", "--foreground" ]
