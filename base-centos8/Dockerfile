################################################################################################################
# escomp/base-centos8 Dockerfile                                                                                    #
#--------------------------------------------------------------------------------------------------------------#
# A base CentOS8 install + MPI, HDF5, NetCDF and PNetCDF, as well as other core packages for escomp containers #
################################################################################################################

# Use latest CentOS8:
FROM escomp/base-centos8

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
