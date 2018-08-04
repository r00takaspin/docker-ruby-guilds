FROM ubuntu:18.04
RUN apt-get update
RUN apt-get install git autoconf ruby gcc make bison libssl-dev  -y
RUN git clone https://github.com/ko1/ruby
WORKDIR /ruby
RUN git checkout guild
RUN autoconf && ./configure -with-openssl-dir=/usr/local/ssl
RUN make && make install
RUN ruby --version
WORKDIR examples
RUN rm -rf /ruby

