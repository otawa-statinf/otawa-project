# from base image node
FROM ubuntu:latest

# ENV workdirectory /usr/node

# WORKDIR $workdirectory
# WORKDIR app

#### EXAMPLE
#  # Build and set klee user to be owner
#  RUN /tmp/klee_src/scripts/build/build.sh --debug --install-system-deps klee && chown -R klee:klee /tmp/klee_bui
#  ld* && pip3 install flask wllvm && \
#      rm -rf /var/lib/apt/lists/*
#  
#  ENV PATH="$PATH:/tmp/llvm-38-install_O_D_A/bin:/home/klee/klee_build/bin"
#  ENV BASE=/tmp
#  
#  # Add KLEE header files to system standard include folder
#  RUN /bin/bash -c 'ln -s ${BASE}/klee_src/include/klee /usr/include/'
#  
#  USER klee
#  WORKDIR /home/klee
#  ENV LD_LIBRARY_PATH /home/klee/klee_build/lib/
####

RUN apt update && \
	DEBIAN_FRONTEND=noninteractive apt -y --no-install-recommends install \
		sudo vim-nox git python3 g++ ocaml flex bison cmake libxml2-dev libxslt1-dev build-essential perl && \
	useradd -m statinf && \
	echo statinf:statinf | chpasswd && \
	cp /etc/sudoers /etc/sudoers.bak && \
	echo 'statinf  ALL=(root) NOPASSWD: ALL' >> /etc/sudoers

USER statinf
WORKDIR /home/statinf

# Copy benchmarks onto image
# COPY --chown=statinf:statinf ./benchmarks /home/statinf/benchmarks/

RUN git clone --branch=tms --recursive https://github.com/jordr/otawa-project otawa-project # && cd otawa-project && git rev-parse HEAD

WORKDIR /home/statinf/otawa-project 
RUN cd ./elm       && git checkout master && cmake -DCMAKE_INSTALL_PREFIX=../otawa-install . && make && make install
RUN cd ./gel       && git checkout master && cmake -DCMAKE_INSTALL_PREFIX=../otawa-install . && make && make install
RUN cd ./gelpp     && git checkout master && cmake -DCMAKE_INSTALL_PREFIX=../otawa-install . && make && make install
RUN cd ./gliss2    && git checkout master && make
RUN	cd ./tms       && git checkout master && make
RUN cd ./otawa     && git checkout master && cmake -DCMAKE_INSTALL_PREFIX=../otawa-install . && make -j4 && make install
RUN cd ./otawa-tms && git checkout master && cmake -DCMAKE_INSTALL_PREFIX=../otawa-install -DOTAWA_CONFIG=../otawa-install/bin/otawa-config . && make && make install
# RUN cd ./otawa     && git checkout master && cmake -DCMAKE_INSTALL_PREFIX=../otawa-install . && make -j4 && make install

# Set proper path
ENV PATH="$PATH:/home/statinf/otawa-project/otawa-install/bin"

# Test
CMD odec /home/statinf/otawa-project/benchmarks/main5.out


# command executable and version
# ENTRYPOINT ["node"]
