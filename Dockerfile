FROM ubuntu:18.04
RUN apt-get update
RUN apt-get install git autoconf ruby gcc make bison  -y
RUN git clone https://github.com/ko1/ruby
WORKDIR /ruby
RUN git checkout guild
RUN autoconf && ./configure && make && make install
RUN ruby --version

