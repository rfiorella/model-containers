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
    && cmake ../ -DCMAKE_INSTALL_PREFIX=/usr \
    && make -j$(nproc) \
    && make install \
    && cd / \
    && rm -rf /tmp/cprnc \
    && which cprnc

# Build Zoltan for MOAB partitioning.
# MOAB 5.6.0's --download-zoltan ships a stale config.guess/config.sub that
# cannot detect aarch64 ("configure: error: cannot guess build type") when the
# image is built natively on arm64 (e.g. Apple Silicon). Build Zoltan
# standalone and refresh its config scripts with autoreconf -fi so it
# recognizes the host, then point MOAB at it via --with-zoltan below.
RUN cd /tmp \
    && wget -q https://github.com/sandialabs/Zoltan/archive/refs/tags/v3.901.tar.gz -O zoltan.tar.gz \
    && tar xf zoltan.tar.gz \
    && cd Zoltan-3.901 \
    && autoreconf -fi \
    && mkdir build \
    && cd build \
    && ../configure CC=mpicc \
                    CXX=mpicxx \
                    FC=mpif90 \
                    F77=mpif77 \
                    --prefix=/usr \
                    --enable-mpi \
                    --with-mpi-compilers=yes \
    && make -j4 everything \
    && make install \
    && cd /tmp \
    && rm -rf Zoltan-3.901 zoltan.tar.gz

# Build TempestRemap for MOAB remapping.
# MOAB 5.6.0's --download-tempestremap installs its test scripts to
# $prefix/bin/test/ (nobase_dist_bin_SCRIPTS), so with --prefix=/usr the install
# runs "mkdir -p /usr/bin/test/" which collides with the coreutils `test` binary
# already at /usr/bin/test ("cannot create directory '/usr/bin/test/': File
# exists"). Build TempestRemap standalone under /usr/local (no bin/test there)
# and point MOAB at it via --with-tempestremap below.
RUN cd /tmp \
    && git clone --depth 1 --branch v2.2.0 https://github.com/ClimateGlobalChange/tempestremap.git \
    && cd tempestremap \
    && autoreconf -fi \
    && ./configure CC=mpicc \
                   CXX=mpicxx \
                   FC=mpif90 \
                   F77=mpif77 \
                   --prefix=/usr/local \
                   --with-netcdf=/usr \
    && make -j4 \
    && make install \
    && cd /tmp \
    && rm -rf tempestremap

# Build MOAB for coupling infrastructure
RUN cd /tmp \
    && git clone https://bitbucket.org/fathomteam/moab.git \
    && cd moab \
    && git checkout 5.6.0 \
    && autoreconf -fi \
    && ./configure CC=mpicc \
                    CXX=mpicxx \
                    FC=mpif90 \
                    F77=mpif77 \
                    --prefix=/usr \
                    --enable-debug --enable-optimize \
                    --with-mpi=/usr \
                    --with-hdf5=/usr \
                    --with-netcdf=/usr \
                    --with-pnetcdf=/usr \
                    --download-eigen3 \
                    --with-tempestremap=/usr/local \
                    --with-zoltan=/usr \
    && make -j4 \
    && export OMPI_ALLOW_RUN_AS_ROOT=1 OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1 \
    && { make check || { echo "==== MOAB test-suite logs ===="; cat tools/mbcoupler/parcoupler_test.log tools/mbcoupler/test-suite.log 2>/dev/null; exit 1; }; } \
    && make install \
    && cd / \
    && rm -rf /tmp/moab

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
