ARG BASE_IMAGE
ARG TIMEZONE=Etc/UTC

FROM ${BASE_IMAGE}

# Install some useful packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
	ca-certificates python3 python3-venv python-is-python3 \
    git wget sudo vim iputils-ping ssh rsync \
	dirmngr gnupg2 \
	build-essential \
	byobu \
	curl \
	mesa-utils xauth \
	ffmpeg \
	&& rm -rf /var/lib/apt/lists/*
RUN apt-get update && DEBIAN_FRONTEND=noninteractive TZ=${TIMEZONE} apt-get -y install tzdata && rm -rf /var/lib/apt/lists/*


# ----------------------------------------------------------------------
# System setup (up to my personal taste)
# ----------------------------------------------------------------------

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
USER root
ENV PATH $PATH:/root/.local/bin

#Byobu Fix for launching BASH instead of SH
RUN mkdir -p /root/.byobu/
RUN echo 'set -g default-shell /bin/bash' >>/root/.byobu/.tmux.conf
RUN echo 'set -g default-command /bin/bash' >>/root/.byobu/.tmux.conf

RUN echo 'export PS1="\[\033[38;5;34m\]\u@\h\[$(tput sgr0)\]\[\033[38;5;76m\]:\[$(tput sgr0)\]\[\033[38;5;172m\]\w\[$(tput sgr0)\]\[\033[38;5;158m\]\\$\[$(tput sgr0)\] \[$(tput sgr0)\]"' >> /root/.bashrc
RUN echo 'HISTCONTROL=ignoredups:erasedups' >> /root/.bashrc
RUN echo 'shopt -s histappend' >> /root/.bashrc
RUN echo 'PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'} history -a; history -c; history -r"' >> /root/.bashrc
