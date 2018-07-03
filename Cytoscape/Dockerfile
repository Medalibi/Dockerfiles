# Cytoscape
#
# docker run -it --rm -v /tmp/.X11-unix:/tmp/.X11-unix:rw -e DISPLAY=unix$DISPLAY -v $HOME/:/home/training/ --device /dev/dri --name cytoscape ebitraining/cytoscape 
#
#
# docker run -it --rm -v /tmp/.X11-unix:/tmp/.X11-unix:rw -e DISPLAY=unix$DISPLAY -v $HOME/:/home/training/ -v /usr/lib/nvidia-340:/usr/lib/nvidia-340 -v /usr/lib32/nvidia-340:/usr/lib32/nvidia-340 --device /dev/dri --name cytoscape ebitraining/cytoscape:alpha 
#
#
#
# USAGE:
#	# Build cytoscape image
#	docker build -f ./Dockerfile -t cytoscape .
#
#	docker run -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY ebitraining/cytoscape

FROM openjdk:8
LABEL maintainer "Mohamed Alibi <alibimohamed@gmail.com>"

ADD http://chianti.ucsd.edu/cytoscape-3.6.0/Cytoscape_3_6_0_unix.sh /usr/local/Cytoscape_3_6_0_unix.sh

# Install dependencies
RUN apt-get update && apt-get install -y \
	libgl1-mesa-dri libgl1-mesa-glx \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

##ENV JAVA_HOME /usr/bin/java

RUN chmod 777 /usr/local/Cytoscape_3_6_0_unix.sh \
	&& sh /usr/local/Cytoscape_3_6_0_unix.sh -q \
	&& chmod -R 777 /usr/local/Cytoscape_v3.6.0 \
        && ln -s /usr/local/Cytoscape_v3.6.0/cytoscape.sh /usr/bin/cytoscape

RUN rm /usr/local/Cytoscape_3_6_0_unix.sh \
	&& apt-get purge -y --auto-remove wget
	

# nvidia-docker hooks
LABEL com.nvidia.volumes.needed="nvidia_driver"
ENV PATH /usr/lib/nvidia-340/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/lib/nvidia-340:/usr/lib32/nvidia-340:${LD_LIBRARY_PATH}

ENV HOME /home/training

RUN useradd --create-home --home-dir $HOME training \
	&& chown -R training:training $HOME \
	&& usermod -a -G audio,video training

# Grant su previleges to the default user
RUN echo "training ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
	&& chmod 0440 /etc/sudoers


WORKDIR $HOME
USER training

# Autorun cytoscape
#ENTRYPOINT [ "cytoscape", "--foreground" ]
CMD ["cytoscape"]
