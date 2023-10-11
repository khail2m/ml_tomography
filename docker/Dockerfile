#ARG dockerfrom
#FROM $dockerfrom
FROM nvidia/cuda:11.3.0-devel-ubuntu20.04

# to avoid interaction with apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Set default shell to /bin/bash
SHELL ["/bin/bash", "-euo", "pipefail", "-c"]

RUN apt-get update && apt-get install -y --allow-downgrades --allow-change-held-packages --no-install-recommends \
        build-essential \
        cmake \
        g++-7 \
        git \
        curl \
        wget \
        libjpeg-dev \
        libpng-dev \
        vim \
        ca-certificates \
        openssh-client \
        openssh-server \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# pip packages
#RUN pip install torchsummary scikit-image pytorch-lightning

# install additional packages
# random velocity generator
#RUN git clone https://github.com/pkgpl/RandomVelocityGenerator.git /work/RandomVelocityGenerator
#RUN cd /work/RandomVelocityGenerator && python setup.py install

# torchwi
#RUN git clone https://github.com/pkgpl/TorchWI.git /work/TorchWI
#RUN cd /work/TorchWI && python setup.py install

# pkrh
#RUN git clone https://plusha@bitbucket.org/plusha/pkrh.git /work/pkrh
#RUN cd /work/pkrh && python setup.py install
#RUN cd /work/pkrh/programs && make install
#ENV PATH="${PATH}:/work/pkrh/bin"


# docker shell prompt for root
RUN echo 'export PS1="\e[0;31m(docker) \e[m[\u@\h \w]# "' >> /root/.profile

# Create a non-root user
ARG username=dockeruser
ARG groupname=docker
ARG uid=1001
ARG gid=1001
ARG project_dir=my_project

ENV USER $username
ENV UID $uid
ENV GID $gid
ENV USERHOME /home/$USER
ENV PROJECT_DIR $USERHOME/$project_dir

RUN groupadd -f -g $GID $groupname
RUN adduser --disabled-password \
    --gecos "Non-root user" \
    --uid $UID \
    --gid $GID \
    --home $USERHOME \
    $USER

# prepare link
RUN mkdir -p /work/$USER
RUN chown $USER:$groupname /work/$USER

# create a project directory inside user home
USER $USER
ENV CONDABIN /home/$USER/miniconda3/bin

# user environment variables
ENV PATH="${PATH}:$PROJECT_DIR/bin:$CONDABIN"

# conda env
RUN cd $USERHOME; mkdir lib
RUN wget 'https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh' -O $USERHOME/lib/Miniconda3-latest-Linux-x86_64.sh
RUN sh $USERHOME/lib/Miniconda3-latest-Linux-x86_64.sh -b

RUN $CONDABIN/pip install cupy-cuda112
#RUN $CONDABIN/conda install -c conda-forge cupy
RUN $CONDABIN/conda install -y mkl numpy scipy numba tensorboard matplotlib yaml pyyaml jupyter
#RUN $CONDABIN/conda install -y cudatoolkit=10.2 pytorch torchvision -c pytorch
RUN $CONDABIN/conda install pytorch==1.13.0 torchvision==0.14.0 torchaudio==0.13.0 pytorch-cuda=11.7 -c pytorch -c nvidia
#RUN $CONDABIN/conda install pytorch==1.11.0 torchvision==0.12.0 torchaudio==0.11.0 cudatoolkit=10.2 -c pytorch

# random velocity generator
RUN git clone https://github.com/pkgpl/RandomVelocityGenerator.git $USERHOME/lib/RandomVelocityGenerator
RUN cd $USERHOME/lib/RandomVelocityGenerator && $CONDABIN/python setup.py install

# torchwi
RUN git clone https://github.com/pkgpl/TorchWI.git $USERHOME/lib/TorchWI
RUN cd $USERHOME/lib/TorchWI && $CONDABIN/python setup.py install
# pkrh
RUN git clone https://plusha@bitbucket.org/plusha/pkrh.git $USERHOME/lib/pkrh
RUN cd $USERHOME/lib/pkrh && $CONDABIN/python setup.py install
RUN cd $USERHOME/lib/pkrh/programs && make install
ENV PATH="${PATH}:$USERHOME/lib/pkrh/bin"

WORKDIR $PROJECT_DIR

# link to the project directory in /work
RUN ln -s $PROJECT_DIR /work/$USER/$project_dir


# docker shell prompt for user
RUN echo 'export PS1="\e[0;36m(docker) \e[m[\u@\h \w]\$ "' >> $USERHOME/.profile

ENV PATH="$CONDABIN:${PATH}"
