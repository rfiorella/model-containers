# ----------------------------------------------------------------------
# Debian baseOS docker container to use with ELM/CTSM builds
# ----------------------------------------------------------------------

#FROM debian:bullseye
ARG BASE_TAG=base-mpich-latest
FROM rfiorella/model-containers:${BASE_TAG}

## Get docker configuration for E3SM
# where to get the ELM source code
ENV USER=e3smuser

# Add new group, user, and user directory with user permissions
RUN groupadd -r dockerusers \
    && useradd -ms /bin/bash $USER -u 1001 -g dockerusers \
    && chown $USER:dockerusers /home/$USER

USER ${USER}

## Install python libraries for OLMT
RUN pip3 install --break-system-packages --upgrade pip \
    && pip3 install --break-system-packages --upgrade setuptools \
    && pip3 install --break-system-packages --upgrade wheel \
    && pip3 install --break-system-packages numpy Cython \
    && pip3 install --break-system-packages netcdf4 scipy mpi4py \
    && pip3 install --break-system-packages cftime configparser \
    && pip3 install --break-system-packages h5py

USER root

# Build cprnc for baseline comparison
RUN cd /tmp \
    && git clone --depth 1 https://github.com/ESMCI/cprnc.git \
    && cd cprnc \
    && mkdir bld && cd bld \
    && cmake ../ -DCMAKE_INSTALL_PREFIX=/usr/local \
    && make -j$(nproc) \
    && make install \
    && cd / \
    && rm -rf /tmp/cprnc

RUN cd / \
    && mkdir -p /home/$USER/.cime \
    && mkdir -p /home/$USER/baselines/data \
    && mkdir -p /home/$USER/output \
    && mkdir -p /home/$USER/inputdata \
    && chown $USER /home/$USER/.cime \
    && chown $USER /home/$USER/baselines/data \
    && chown $USER /home/$USER/output \
    && chown $USER /home/$USER/inputdata \
    && ln -s /usr/bin/ncap2 /usr/bin/ncap

ADD cime_files /home/$USER/.cime

WORKDIR /home/$USER
USER ${USER}
RUN export USER=${USER} \ 
    && git config --global user.email "e3smuser@dev.null" \
    && git config --global user.name "e3smuser"

### EOF
