# Initialize base image
FROM ros:foxy AS builder

# Set working directory
WORKDIR /root/ros2_workspace

# Setup terminal environment
RUN apt-get update && apt-get install -y wget bash

# Setup conda environment
COPY environment.yml /root/
ENV PATH=/root/miniconda3/bin:${PATH}
RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh &&\
  bash Miniconda3-latest-Linux-x86_64.sh -b -u &&\
  rm -f Miniconda3-latest-Linux-x86_64.sh &&\
  conda init bash &&\
  conda env create --name cg -f /root/environment.yml --force &&\
  rm -f /root/environment.yml


## Stage 2 - For smaller image ##
FROM ros:foxy

# Setup environment
ENV TERM=xterm-256color
ENV PATH=/root/miniconda3/bin:${PATH}
COPY --from=builder /root/ /root/
WORKDIR /root/ros2_workspace
COPY docker/entrypoint.sh /

# Install packages
RUN chmod +x /entrypoint.sh &&\
  apt-get update && apt-get install -y\
  libgl1-mesa-glx \
  vim \
  tmux

# Deploy from entrypoint
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]

# # Setup VNC
# RUN mkdir ~/.vnc
# CMD x11vnc -forever -usepw -create -passwd ros2dev