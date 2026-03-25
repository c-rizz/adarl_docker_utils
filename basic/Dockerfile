ARG BASE_IMAGE
ARG TIMEZONE=Etc/UTC

FROM ${BASE_IMAGE}

# Install some useful packages
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
	ca-certificates python3 python3-venv python-is-python3 python3-dev \
    git wget sudo vim iputils-ping ssh rsync \
	dirmngr gnupg2 \
	build-essential \
	byobu \
	curl \
	mesa-utils xauth \
	ffmpeg \
    bash-completion \
	libegl1 libgles2 libegl-mesa0 libgl1-mesa-dri \
	intel-media-va-driver libva-drm2 \
	&& rm -rf /var/lib/apt/lists/*
RUN apt-get update && DEBIAN_FRONTEND=noninteractive TZ=${TIMEZONE} apt-get -y install tzdata && rm -rf /var/lib/apt/lists/*

# Tell the NVIDIA Container Toolkit to mount all driver libs (EGL, GLX, compute, etc.)
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=all

# Add the NVIDIA EGL vendor ICD so the EGL loader (libEGL.so) can find libEGL_nvidia.so.0.
# The toolkit mounts the .so at runtime but doesn't always inject the JSON on Ubuntu 24.04.
RUN mkdir -p /usr/share/glvnd/egl_vendor.d && \
    printf '{"file_format_version":"1.0.0","ICD":{"library_path":"libEGL_nvidia.so.0"}}' \
    > /usr/share/glvnd/egl_vendor.d/10_nvidia.json

# ----------------------------------------------------------------------
# System setup (up to my personal taste)
# ----------------------------------------------------------------------

# setup environment
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
USER root
ENV PATH=$PATH:/root/.local/bin

#Byobu Fix for launching BASH instead of SH
RUN mkdir -p /root/.byobu/
RUN echo 'set -g default-shell /bin/bash' >>/root/.byobu/.tmux.conf
RUN echo 'set -g default-command /bin/bash' >>/root/.byobu/.tmux.conf

RUN sudo rm /etc/apt/apt.conf.d/docker-clean

RUN echo 'export PS1="\[\033[38;5;34m\]\u@\h\[$(tput sgr0)\]\[\033[38;5;76m\]:\[$(tput sgr0)\]\[\033[38;5;172m\]\w\[$(tput sgr0)\]\[\033[38;5;158m\]\\$\[$(tput sgr0)\] \[$(tput sgr0)\]"' >> /root/.bashrc
RUN echo 'HISTCONTROL=ignoredups:erasedups' >> /root/.bashrc
RUN echo 'shopt -s histappend' >> /root/.bashrc
RUN echo 'PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'} history -a; history -c; history -r"' >> /root/.bashrc

# Install UV

# Download the latest installer
ADD https://astral.sh/uv/install.sh /uv-installer.sh
# Run the installer then remove it
RUN sh /uv-installer.sh && rm /uv-installer.sh
# Ensure the installed binary is on the `PATH`
ENV PATH="/root/.local/bin/:$PATH"
