#----------------------------------------------------------------------
# Debian container - gcc8.5. ARM64 version
# E3SM/ELM land model docker container
#
#
# Notes from Rich to get SSH keys to work with private E3SM repos:
#=======================================================================
# This dockerfile allows cloning E3SM by 'borrowing' the SSH key on the 
# host machine building the container:

# 1) This dockerfile assumes you have an SSH key using the ed25519 algorithm.
# you can check which keys you have available by: ls -a ~/.ssh/id*
# if you only have an RSA key for example (eg., id_rsa instead of id_ed25519)
# you'll need to change the key files below to match the key available on your system.
#
# 2) The SSH key used when building this dockerfile must not have a passphrase (or,
# i haven't figured out how to get it to build without one anyway). If you have a passphrase,
# you could remove the passphrase for building, and restore the passphrase later 
# using: ssh-keygen -p
#
# 3) build the container using: docker build -t <your-tag-here> -f Dockerfile_arm64_dev 
#           --build-arg ssh_pub_key="$(cat ~/.ssh/id_ed25519.pub)" --build-arg ssh_prv_key="$(cat ~/.ssh/id_ed25519)" 
#           --squash .
#
# the build-arg arguments pass the public and private keys on your machine to
# the container without them ever being printed to the screen. they are then
# removed after E3SM is cloned (see below). I've seen the --squash flag recommended 
# for extra security - my understanding is that it makes the container a single layer 
# to remove some of the details about the ssh keys (e.g., potential variable expansion)
# at ~L. 88 below. note the build command needs to match the ssh keys on your system in point 1.
# note the --squash flag requires experimental features to be turned on in Docker desktop
# (preferences->Docker Engine on macos/docker desktop 4.11.1 )
# ----------------------------------------------------------------------

FROM gitlab.lanl.gov:5050/rfiorella/e3sm-dev-container:debian11-gcc94-ompi412 
LABEL maintainer.name="Shawn P. Serbin" \
      maintainer.email="sserbin@bnl.gov" \
      author.name="Shawn P. Serbin" \
      author.email="sserbin@bnl.gov" \
      description="ELM host land model" \
      version.hlm="elm_v2-for-ngee" \
      version.baseos="gcc8.5"

# where to get the ELM source code
ENV REPOSITORY_RAW_URL=https://raw.githubusercontent.com/FASSt-simulation/simulation_containers
ENV USER=modeluser

# Add new group, user, and user directory with user permissions
RUN groupadd -r dockerusers \
    && useradd -ms /bin/bash $USER -u 1001 -g dockerusers \
    && chown $USER:dockerusers /home/$USER

## create data mount point in container
## could change this to /mnt or something more generic in machines files
RUN cd / \
    && mkdir -p inputdata \
    && mkdir -p example_inputs \
    && mkdir -p output \
    && mkdir -p scripts \
    && mkdir -p tools \
    && mkdir -p tools/cprnc \
    && mkdir -p baselines \
    && mkdir -p .cime \
    && mkdir -p home/$USER/.cime \
    && chown $USER inputdata \
    && chown $USER example_inputs \
    && chown $USER output \
    && chown $USER scripts \
    && chown $USER tools \
    && chown $USER tools/cprnc \
    && chown $USER baselines \
    && chown $USER .cime \
    && chown $USER /home/$USER/.cime \
    && cd /

# copy keys over to be able to clone E3SM - note
# need to add --squash argument to ensure keys aren't
# available in image:

ARG ssh_prv_key
ARG ssh_pub_key

# authorize ssh host, add keys, set permissions:
RUN mkdir -p /root/.ssh \
    && chmod 0700 /root/.ssh \
    && ssh-keyscan github.com > /root/.ssh/known_hosts \
    && echo "$ssh_prv_key" > /root/.ssh/id_ed25519 \
    && echo "$ssh_pub_key" > /root/.ssh/id_ed25519.pub \
    && chmod 600 /root/.ssh/id_ed25519 \
    && chmod 600 /root/.ssh/id_ed25519.pub

## Checkout ELM model
RUN git clone -b elm_v2-for-ngee --recursive https://github.com/fmyuan/E3SM.git \ 
    && chmod -R 777 /E3SM \
    && cd /E3SM \
    && cd /E3SM/cime_config/machines/cmake_macros \
    && rm gnu.cmake \
    && wget $REPOSITORY_RAW_URL/main/docker/elm/cime_config/gnu.cmake \
    && cd /.cime \
    && wget $REPOSITORY_RAW_URL/main/docker/elm/cime_config/config \
    && wget $REPOSITORY_RAW_URL/main/docker/elm/cime_config/config_compilers.xml \
    && wget $REPOSITORY_RAW_URL/main/docker/elm/cime_config/config_machines.xml \
    && wget $REPOSITORY_RAW_URL/main/docker/elm/cime_config/gnu_docker.cmake \
    && cd /home/$USER/.cime \
    && wget $REPOSITORY_RAW_URL/main/docker/elm/cime_config/config \
    && wget $REPOSITORY_RAW_URL/main/docker/elm/cime_config/config_compilers.xml \
    && wget $REPOSITORY_RAW_URL/main/docker/elm/cime_config/config_machines.xml \
    && wget $REPOSITORY_RAW_URL/main/docker/elm/cime_config/gnu_docker.cmake \
    && cd / \
    && ln -s /usr/bin/ncap2 /usr/bin/ncap \
    && chown $USER:dockerusers /E3SM \
    && export USER=${USER}

# remove SSH keys:
RUN rm -rf /root/.ssh

# Set user
USER ${USER}

## ------------------------------------------------------------------------------
## Build example case as a test  --- only used with initial Docker build testing
RUN cd /E3SM/cime/scripts \
    && export CASE_NAME=/output/f19_g16.IGSWELMBGC \
    && cd /E3SM/cime/scripts \
    && ./create_newcase --case ${CASE_NAME} --res f19_g16 --compset IGSWELMBGC --mach docker --compiler gnu \
    && cd ${CASE_NAME} \
    && ./xmlchange DATM_CLMNCEP_YR_END=1995 \
    && ./xmlchange PIO_TYPENAME=netcdf \
    && ./xmlchange RUNDIR=${PWD}/run \
    && ./xmlchange EXEROOT=${PWD}/bld \
    && ./xmlchange NTASKS=1 \
    && ./xmlchange DIN_LOC_ROOT=$PWD \
    && cd ${CASE_NAME} \
    && ./case.setup \
    && ./case.build

RUN echo "*** ELM test build completed successfully ***"

## Remove test build
RUN cd / \
    && rm -rf /output/f19_g16.IGSWELMBGC
## ------------------------------------------------------------------------------

## Install OLMT tool into the container to use with site or ensemble simulations
RUN cd /tools \
    && git -c http.sslVerify=false clone -b Arctic-userpft --single-branch https://github.com/dmricciuto/OLMT.git \
    && cd OLMT/ \
    && chown $USER:dockerusers -R /tools/OLMT \
    && chmod -R 777 /tools/OLMT

USER ${USER}
RUN export USER=${USER}

## END
