## setup a docker file to compile WRF libraries, and add WRF.
# compiling WRF and WPS needs to be done interactively due
# to the interactive menus, but a version of the container
# with the compiled model can be saved with docker commit.
#---------------------------------------------------------
# rpf updated 231201

ARG BASE_TAG=base-mpich-latest
FROM rfiorella/model-containers:${BASE_TAG}

ENV H5DIR=/usr/ \
    HDF5=/usr/ \
    PHDF5=/usr/ \
    NCDIR=/usr/ \
    NETCDF=/usr/ \
    NFDIR=/usr/ \
    PNETCDF=/usr/ \
    JASPERINC=/usr/include \
    JASPERLIB=/usr/lib \
    PATH=/usr/bin:$PATH \
    LD_LIBRARY_PATH=/usr/lib:$LD_LIBRARY_PATH

# jasPER
RUN wget https://www.zlib.net/current/zlib.tar.gz \
  && tar xzvf zlib.tar.gz \
  && cd zlib-1.3.1 \
  && ./configure --prefix=/usr \
  && make \
  && make install \
  && cd .. \
  && rm -rf zlib* \
  && wget https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/libpng-1.2.50.tar.gz \
  && tar xzvf libpng-1.2.50.tar.gz \
  && cd libpng-1.2.50 \
  && if [ `uname -i` = "aarch64" ] ; then \
     ./configure --build=aarch64-unknown-linux-gnu --prefix=/usr ; \
    else \
      ./configure --prefix=/usr ; \
    fi \
  && make \
  && make install \
  && cd .. \
  && rm -rf libpng* \
  && wget https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/jasper-1.900.1.tar.gz \
  && tar xzvf jasper-1.900.1.tar.gz \
  && cd jasper-1.900.1 \
  && if [ `uname -i` = "aarch64" ] ; then \
     ./configure --build=aarch64-unknown-linux-gnu --prefix=/usr ; \
    else \
      ./configure --prefix=/usr ; \
    fi \
  && make \
  && make install \
  && cd .. \
  && rm -rf jasper*

# set display variables:
ENV DISPLAY=host.docker.internal:0

# change user
RUN mkdir -p /home/wrfuser/WPS && mkdir -p /home/wrfuser/WRF

# COPY:
ADD wrf_tag/WRF_Hydro_Iso_Tag /home/wrfuser/WRF/
ADD wrf/WPS /home/wrfuser/WPS/

RUN groupadd -r wrfuser \
    && useradd -r -m -g wrfuser wrfuser \
    && chown -R wrfuser /home \
    && chgrp -R wrfuser /home
USER wrfuser
WORKDIR /home/wrfuser/WRF
