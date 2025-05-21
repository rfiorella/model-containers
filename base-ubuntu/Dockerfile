# ----------------------------------------------------------------------
# Debian baseOS docker container to use with ELM/CTSM builds
# ----------------------------------------------------------------------

FROM ubuntu:jammy

# Set a few variables that can be used to control the docker build
ARG HDF5_VERSION=1.12.3
ARG NETCDF_VERSION=4.9.2
ARG NETCDF_FORTRAN_VERSION=4.6.1
ARG build_mpi=False
ARG mpi_flavor=openmpi
ARG mpi_version=5.0.6

# Update the system and install initial dependencies
RUN ln -snf /usr/share/zoneinfo/$CONTAINER_TIMEZONE /etc/localtime && echo $CONTAINER_TIMEZONE > /etc/timezone \
    && apt-get update -y \
    && apt-get upgrade -y && apt-get install -y tzdata \
    && apt-get install -y \
    cmake \
    git \
    gcc \
    gfortran \
    expat \
    subversion \
    bzip2 \
    unzip \
    libgmp3-dev \
    m4 \
    autoconf \
    automake \
    libtool \
    wget \
    libcurl4-openssl-dev \
    zlib1g-dev \
    libncurses5-dev \
    csh \
    liblapack-dev \
    libblas-dev \
    libffi7 \
    libffi-dev \
    libxml-libxml-perl \
    libxml2-utils \
    libxml2 \
    libxml2-dev \
    libswitch-perl \
    vim \
    libudunits2-0 \
    libudunits2-dev \
    udunits-bin \
    python3 \
    python3-dev \
    python3-pip \
    python-is-python3 \
    apt-utils \
    ftp \
    apt-transport-https \
    libssl-dev \
    openssl \
    libncurses5-dev \
    gsl-bin \
    libgsl-dev \
    flex \
    nco \
    ncview \
    locales \
    gdb \
    valgrind \
    # install MPI
    && if [ "$build_mpi" = "True" ]; then \
      if [ "$mpi_flavor" = "mpich" ]; then cd / \
        && wget https://www.mpich.org/static/downloads/${mpi_version}/mpich-${mpi_version}.tar.gz \
        && tar xvf mpich-${mpi_version}.tar.gz \
        && cd mpich-${mpi_version} \
        && ./configure --enable-shared --with-device=ch3:sock --enable-fast=all,Os --prefix=/usr \
        && make \
        && make install \
        && cd ../ \
        && rm -r mpich-${mpi_version}/ \
        && rm mpich-${mpi_version}.tar.gz ; \
      elif [ "$mpi_flavor" = "openmpi" ]; then cd / \
        && export mpi_version_major=`echo ${mpi_version} | cut -c1-3` && echo $mpi_version_major \
        && wget https://download.open-mpi.org/release/open-mpi/v${mpi_version_major}/openmpi-${mpi_version}.tar.gz \
        && tar xvf openmpi-${mpi_version}.tar.gz \
        && cd openmpi-${mpi_version} \
        && ./configure --enable-shared --prefix=/usr \
        && make \
        && make install \
        && cd ../ \
        && rm -r openmpi-${mpi_version}/ \
        && rm openmpi-${mpi_version}.tar.gz ; \
      else \
        echo "Unknown mpi_flavor - exiting." \
        && exit 1 ; \
      fi \
    else apt-get install -y lib${mpi_flavor}-dev ; fi \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean all \
    && apt autoremove

## Set default locale for the environment
ENV LC_ALL=C.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

## HDF5 - use alternative source since main HDF5 source doesnt have useful download links
#https://support.hdfgroup.org/ftp/HDF5/releases/
RUN cd / \
    && wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.12/hdf5-${HDF5_VERSION}/src/hdf5-${HDF5_VERSION}.tar.gz \
    && tar -zxvf hdf5-${HDF5_VERSION}.tar.gz \
    && cd hdf5-${HDF5_VERSION} \
    && CC=mpicc FC=mpifort CPPFLAGS="-fPIC -O2" ./configure --enable-fortran --enable-parallel --prefix=/usr \
    && make \
    && make install \
    && cd / \
    && rm -r hdf5-${HDF5_VERSION} \
    && rm hdf5-${HDF5_VERSION}.tar.gz

## PnetCDF
RUN cd / \
    && git clone --depth 1 --branch checkpoint.1.13.0 https://github.com/Parallel-NetCDF/PnetCDF.git \
    && cd PnetCDF \
    && autoreconf -i \
    && CC=mpicc FC=mpifort CPPFLAGS="-fPIC -O2" ./configure --disable-in-place-swap --prefix=/usr/ \
    && make \
    && make install \
    && cd / \
    && rm -r PnetCDF/

## netCDF
RUN cd / \
    && wget https://downloads.unidata.ucar.edu/netcdf-c/${NETCDF_VERSION}/netcdf-c-${NETCDF_VERSION}.tar.gz \
    && tar -zxvf netcdf-c-${NETCDF_VERSION}.tar.gz \
    && cd netcdf-c-${NETCDF_VERSION} \
    && export H5DIR=/usr \
    && export NCDIR=/usr \
    && CC=mpicc CPPFLAGS="-I${H5DIR}/include -fPIC -O2" LDFLAGS="-L${H5DIR}/lib -lpnetcdf" ./configure --enable-parallel-tests --enable-pnetcdf --prefix=${NCDIR} \
    && make \
    && make install \
    && cd / \
    && rm -r netcdf-c-${NETCDF_VERSION} \
    && rm netcdf-c-${NETCDF_VERSION}.tar.gz \
    && wget https://downloads.unidata.ucar.edu/netcdf-fortran/${NETCDF_FORTRAN_VERSION}/netcdf-fortran-${NETCDF_FORTRAN_VERSION}.tar.gz \
    && tar -zxvf netcdf-fortran-${NETCDF_FORTRAN_VERSION}.tar.gz \
    && cd netcdf-fortran-${NETCDF_FORTRAN_VERSION} \
    && export NCDIR=/usr \
    && export NFDIR=/usr \
    && FC=mpifort CC=mpicc CPPFLAGS="-I${NCDIR}/include -I${H5DIR}/include -fPIC -O2" LDFLAGS="-L${NCDIR}/lib -L${H5DIR}/lib" ./configure --prefix=${NFDIR} --enable-parallel-tests \
    && make \
    && make install \
    && cd / \
    && rm -r netcdf-fortran-${NETCDF_FORTRAN_VERSION} \
    && rm netcdf-fortran-${NETCDF_FORTRAN_VERSION}.tar.gz

# install ADIOS
RUN cd / \
   && git clone https://github.com/ornladios/ADIOS2.git ADIOS2 \
   && mkdir adios2-build && cd adios2-build \
   && cmake ../ADIOS2 \
   && make -j 4 \
   && ctest \
   && make install \
   && rm -r ../ADIOS2 \
   && cd / \
   && rm -r adios2-build \
   && cd /

### EOF
