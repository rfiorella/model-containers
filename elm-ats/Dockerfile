# Dockerfile to build ELM-ATS from the amanzi-tpls image

FROM metsi/amanzi-tpls:0.98.7-mpich AS ats-build

ADD ATS-for-ELM /home/amanzi_user/amanzi/src/physics/ats/
USER root 
RUN chown -R amanzi_user /home/amanzi_user/amanzi/src/physics/ats \ 
    && chgrp -R amanzi_user /home/amanzi_user/amanzi/src/physics/ats
# Switch to amanzi_user and set up env
USER amanzi_user

RUN echo "${AMANZI_PREFIX}"
RUN echo "${AMANZI_TPLS_DIR}"

ENV https_proxy=$https_proxy \
    http_proxy=$http_proxy

# Change the Working Directory 
WORKDIR /home/amanzi_user/amanzi

ENV AMANZI_SRC_DIR=/home/amanzi_user/amanzi \
    ATS_SRC_DIR=/home/amanzi_user/amanzi/src/physics/ats 
  
RUN ./bootstrap.sh --prefix=${AMANZI_PREFIX} \
   --amanzi-build-dir=/home/amanzi_user/amanzi_builddir/ats \
   --tpl-config-file=${AMANZI_TPLS_DIR}/share/cmake/amanzi-tpl-config.cmake \
   --parallel=4 \
   --opt \
   --with-mpi=/usr \
   --enable-shared \
   --disable-structured \
   --disable-build_user_guide \
   --enable-geochemistry \
   --disable-amanzi_physics \
   --enable-ats_physics \
   --ats_dev \
   --enable-reg_tests \
   --enable-test_suite

   # Set path to make it easier to run amanzi
ENV PATH=/home/amanzi_user/install/bin:${PATH}
RUN echo $PATH

# Create mount point for work on the host
RUN mkdir /home/amanzi_user/work

#### Add E3SM version:
ADD ELM-ATS /home/amanzi_user/E3SM
