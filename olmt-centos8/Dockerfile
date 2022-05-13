################################################################################################################
# escomp/base-centos8 Dockerfile                                                                                    #
#--------------------------------------------------------------------------------------------------------------#
# A base CentOS8 install + MPI, HDF5, NetCDF and PNetCDF, as well as other core packages for escomp containers #
################################################################################################################

# Use latest CentOS8:
FROM escomp/base-centos8

# centos8 workaround
RUN dnf -y --allowerasing --disablerepo '*' --enablerepo=extras swap centos-linux-repos centos-stream-repos
RUN yum -y update && yum -y install python3-devel 

RUN pip3 install wheel
RUN pip3 install numpy
RUN pip3 install Cython
RUN pip3 install cftime
RUN pip3 install netcdf4

# link python3 to python
RUN ln -s /usr/bin/python3 /usr/bin/python

# install nco
RUN dnf --enablerepo=powertools install -y nco

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
