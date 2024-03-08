## setup a docker file to compile WRF libraries, and add WRF.
# compiling WRF and WPS needs to be done interactively due
# to the interactive menus, but a version of the container
# with the compiled model can be saved with docker commit.
#---------------------------------------------------------
# rpf updated 231201

FROM gitlab.lanl.gov:5050/rfiorella/model-containers/baseos:latest

ENV H5DIR=/usr/local/hdf5 \
    HDF5=/usr/local/hdf5 \
    PHDF5=/usr/local/hdf5 \
    NCDIR=/usr/local/netcdf \
    NETCDF=/usr/local/netcdf \
    NFDIR=/usr/local/netcdf \
    PNETCDF=/usr/local/pnetcdf \
    JASPERINC=/usr/local/grib2/include \
    JASPERLIB=/usr/local/grib2/lib \
    PATH=/usr/local/grib2/bin:/usr/local/hdf5/bin:/usr/local/netcdf/bin:/usr/local/pnetcdf/bin:$PATH \
    LD_LIBRARY_PATH=/usr/local/grib2/lib:/usr/local/hdf5/lib:/usr/local/netcdf/lib:/usr/local/pnetcdf/lib:$LD_LIBRARY_PATH

# jasPER
RUN wget https://www.zlib.net/current/zlib.tar.gz \
  && tar xzvf zlib.tar.gz \
  && cd zlib-1.3.1 \
  && ./configure --prefix=/usr/local/grib2 \
  && make \
  && make install \
  && cd .. \
  && rm -rf zlib* \
  && wget https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/libpng-1.2.50.tar.gz \
  && tar xzvf libpng-1.2.50.tar.gz \
  && cd libpng-1.2.50 \
  && if [ `uname -i` = "aarch64" ] ; then \
     ./configure --build=aarch64-unknown-linux-gnu --prefix=/usr/local/grib2 ; \
    else \
      ./configure --prefix=/usr/local/grib2 ; \
    fi \
  && make \
  && make install \
  && cd .. \
  && rm -rf libpng* \
  && wget https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/jasper-1.900.1.tar.gz \
  && tar xzvf jasper-1.900.1.tar.gz \
  && cd jasper-1.900.1 \
  && if [ `uname -i` = "aarch64" ] ; then \
     ./configure --build=aarch64-unknown-linux-gnu --prefix=/usr/local/grib2 ; \
    else \
      ./configure --prefix=/usr/local/grib2 ; \
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
ADD WRF /home/wrfuser/WRF/
ADD WPS /home/wrfuser/WPS/

RUN groupadd -r wrfuser \
    && useradd -r -m -g wrfuser wrfuser \
    && chown -R wrfuser /home \
    && chgrp -R wrfuser /home
USER wrfuser
WORKDIR /home/
