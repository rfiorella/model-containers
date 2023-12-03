# ----------------------------------------------------------------------
# Debian baseOS docker container to use with ELM/CTSM builds
# ----------------------------------------------------------------------

#FROM debian:bullseye
FROM gitlab.lanl.gov:5050/rfiorella/model-containers/baseos:latest

## Get docker configuration for E3SM
# where to get the ELM source code
ENV REPOSITORY_URL=https://github.com/rfiorella/simulation_containers
ENV REPOSITORY_RAW_URL=https://raw.githubusercontent.com/rfiorella/simulation_containers
ENV TOOLS_REPOSITORY_RAW_URL=https://raw.githubusercontent.com/rfiorella/fasst_simulation_tools
ENV USER=e3smuser

# Add new group, user, and user directory with user permissions
RUN groupadd -r dockerusers \
    && useradd -ms /bin/bash $USER -u 1001 -g dockerusers \
    && chown $USER:dockerusers /home/$USER

USER ${USER}

## Install python libraries for OLMT
RUN pip3 install --upgrade pip \
    && pip3 install --upgrade setuptools \
    && pip3 install --upgrade wheel \
    && pip3 install numpy Cython \
    && pip3 install netcdf4 scipy mpi4py \
    && pip3 install cftime configparser h5py

USER root

RUN cd / \
    && mkdir -p .cime \
    && mkdir -p /home/$USER/.cime \
    && mkdir -p /home/$USER/baselines \
    && mkdir -p /home/$USER/output \
    && mkdir -p /home/$USER/inputdata \
    && mkdir -p /home/$USER/tools \
    && chown $USER .cime \
    && chown $USER /home/$USER/.cime \
    && chown $USER /home/$USER/baselines \
    && chown $USER /home/$USER/output \
    && chown $USER /home/$USER/inputdata \
    && chown $USER /home/$USER/tools

RUN cd /.cime \
    && wget $REPOSITORY_RAW_URL/main/docker/elm/cime_config/config \
    && wget $REPOSITORY_RAW_URL/main/docker/elm/cime_config/config_compilers.xml \
    && wget $REPOSITORY_RAW_URL/main/docker/elm/cime_config/config_machines.xml \
    && wget $REPOSITORY_RAW_URL/main/docker/elm/cime_config/gnu_docker.cmake \
    && wget $REPOSITORY_RAW_URL/main/docker/elm/cime_config/gnu_docker8.cmake \
    && wget $REPOSITORY_RAW_URL/main/docker/elm/cime_config/gnu_docker16.cmake \
    && cd /home/$USER/.cime \
    && wget $REPOSITORY_RAW_URL/main/docker/elm/cime_config/config \
    && wget $REPOSITORY_RAW_URL/main/docker/elm/cime_config/config_compilers.xml \
    && wget $REPOSITORY_RAW_URL/main/docker/elm/cime_config/config_machines.xml \
    && wget $REPOSITORY_RAW_URL/main/docker/elm/cime_config/gnu_docker.cmake \
    && wget $REPOSITORY_RAW_URL/main/docker/elm/cime_config/gnu_docker8.cmake \
    && wget $REPOSITORY_RAW_URL/main/docker/elm/cime_config/gnu_docker16.cmake \
    && cd / \
    && ln -s /usr/bin/ncap2 /usr/bin/ncap

WORKDIR /home/$USER
USER ${USER}
RUN export USER=${USER}
### EOF
