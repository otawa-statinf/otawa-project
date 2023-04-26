# from base image node
FROM ubuntu:latest

# ENV workdirectory /usr/node

RUN apt update && \
	DEBIAN_FRONTEND=noninteractive apt -y --no-install-recommends install \
		sudo vim-nox git python3 g++ ocaml flex bison cmake libxml2-dev libxslt1-dev build-essential perl graphviz && \
	useradd -m statinf && \
	echo statinf:statinf | chpasswd && \
	cp /etc/sudoers /etc/sudoers.bak && \
	echo 'statinf  ALL=(root) NOPASSWD: ALL' >> /etc/sudoers

USER statinf
WORKDIR /home/statinf

RUN git clone  --branch=tms --recursive https://github.com/jordr/otawa-project otawa-project # && cd otawa-project && git rev-parse HEAD

WORKDIR /home/statinf/otawa-project 
# RUN git checkout ...
RUN ls && cd ./elm             && git checkout master && cmake -DCMAKE_INSTALL_PREFIX=../otawa-install . && make && make install
RUN cd ./gel             && git checkout master && cmake -DCMAKE_INSTALL_PREFIX=../otawa-install . && make && make install
RUN cd ./gelpp           && git checkout master && cmake -DCMAKE_INSTALL_PREFIX=../otawa-install . && make && make install
RUN cd ./gliss2          && git checkout master && make
RUN	cd ./tms             && git checkout master && make
RUN cd ./otawa           && git checkout cycles && cmake -DCMAKE_INSTALL_PREFIX=../otawa-install . && make -j4 && make install
RUN cd ./otawa-tms       && git checkout master && cmake -DCMAKE_INSTALL_PREFIX=../otawa-install -DOTAWA_CONFIG=../otawa-install/bin/otawa-config . && make && make install
RUN cd ./lp_solve5       && git checkout master && cmake . && make 
RUN cd ./otawa-lp_solve5 && git checkout master && cmake -DCMAKE_INSTALL_PREFIX=../otawa-install . -DOTAWA_CONFIG=../otawa-install/bin/otawa-config . && make && make install
# Re-build OTAWA?
RUN cd ./otawa           && make -j4 && make install
RUN cd ./obsview         && git checkout master && cmake -DCMAKE_INSTALL_PREFIX=../otawa-install . && make install

# Set proper path
ENV PATH="$PATH:/home/statinf/otawa-project/otawa-install/bin"

# Test
CMD odec /home/statinf/otawa-project/benchmarks/main5.out

# # Copy benchmarks onto image, including .out and .ff
# COPY --chown=statinf:statinf ./benchmarks /home/statinf/benchmarks/
# # Run OTAWA on LTS application
# # mkff generates a placeholder .ff file, we are not using its output at the moment as we require a .ff file to be provided
# CMD mkff /home/statinf/benchmarks/app/CPU1.out
# # Look for the entry point (here, __KCG__APPLICATIVE_SOFTWARE_FAST)
# CMD gel-sym /home/statinf/benchmarks/app/CPU1.out
# # Compute WCET and output statistics
# CMD owcet -s trivial --stats /home/statinf/benchmarks/app/CPU1.out __KCG__APPLICATIVE_SOFTWARE_FAST
# # Run the CFG viewer
# # Must run docker with -p 37605:37605
# # Alternatively, RUN sudo apt install -y firefox and do not use --serve --port 37605
# CMD obviews.py /home/statinf/benchmarks/app/CPU1.out __KCG__APPLICATIVE_SOFTWARE_FAST --serve --port 37605
