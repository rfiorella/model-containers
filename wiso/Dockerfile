###############################################################################################################
# escomp/base-centos8 Dockerfile                                                                                    #
#--------------------------------------------------------------------------------------------------------------#
# A base CentOS8 install + MPI, HDF5, NetCDF and PNetCDF, as well as other core packages for escomp containers #
################################################################################################################

# Use latest CentOS8:
FROM gitlab.lanl.gov:5050/rfiorella/e3sm-dev-container:debian11-gcc94-ompi412 

ENV REPOSITORY_RAW_URL=https://raw.githubusercontent.com/FASSt-simulation/simulation_containers

## Checkout ELM model
RUN sudo mkdir /E3SM \
    && cd / \
    && git clone -b rfiorella/eam/wiso --recursive https://github.com/rfiorella/E3SM.git \ 
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
    && ln -s /usr/bin/ncap2 /usr/bin/ncap 

RUN groupadd e3sm && \
    useradd -c 'E3SM User' -d /home/user -g e3sm -m -s /bin/bash user && \
    echo 'export USER=$(whoami)' >> /etc/profile.d/e3sm.sh && \
    echo 'export PS1="[\u@e3sm \W]\$ "' >> /etc/profile.d/e3sm.sh && \
    echo 'user ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/e3sm

ENV SHELL=/bin/bash \
    LANG=C.UTF-8  \
    LC_ALL=C.UTF-8

USER user
WORKDIR /home/user
CMD ["/bin/bash", "-l"]
#ENTRYPOINT ["/bin/bash", "-l"]
