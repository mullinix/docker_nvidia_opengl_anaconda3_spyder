FROM nvidia/opengl:1.0-glvnd-runtime-ubuntu16.04

ARG conda_ver=Anaconda3-2019.03-Linux-x86_64

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

# graphics libraries/packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    mesa-utils libgl1-mesa-glx libxcomposite1 libxcursor1 \
    libxi6 libxtst6 libxss1 libxrandr2 libasound2 libegl1-mesa 
    
# base packages for installing anaconda3
RUN apt-get install -y --no-install-recommends \
    wget curl bzip2 

# font packages
RUN apt-get install -y --no-install-recommends \
    fonts-cantarell lmodern ttf-aenigma ttf-georgewilliams \
    ttf-bitstream-vera ttf-sjfonts fonts-tuffy tv-fonts \
    ubuntustudio-font-meta
    
# development packages
RUN apt-get install -y --no-install-recommends \
    vim build-essential git openssh-client

# link libraries via driver conf files
RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf 
RUN echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

# download anaconda 3, install, cleanup, set permissions
RUN wget -O anaconda-install.sh https://repo.continuum.io/archive/$conda_ver.sh --no-check-certificate && \
	chmod +x anaconda-install.sh && \
	/bin/bash anaconda-install.sh -b -p /opt/conda && \
	rm anaconda-install.sh

# cleanup installation to reduce size
RUN rm -rf /var/lib/apt/lists/*

# install PySimpleGUI+BioPython libs (for custom python scripts -- omit otherwise)
RUN /opt/conda/bin/pip install PySimpleGUI biopython

# establish user, home directory
RUN useradd -rm -d /home/developer -s /bin/bash \
    -g root -G root -u 1000 developer
USER developer
ENV HOME /home/developer


# ENVs from singularity definition recipe (from nvidia gitlab)
ENV LD_LIBRARY_PATH /usr/lib/x86_64-linux-gnu:/usr/lib/i386-linux-gnu${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}:/usr/local/nvidia/lib:/usr/local/nvidia/lib64
ENV NVIDIA_VISIBLE_DEVICES ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics,compat32,utility

CMD [ "/bin/bash" ]
