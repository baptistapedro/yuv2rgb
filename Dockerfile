FROM fuzzers/afl:2.52

RUN apt-get update
RUN apt install -y build-essential wget git clang  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev     libboost-all-dev libssl-dev
RUN  git clone https://github.com/descampsa/yuv2rgb.git
WORKDIR /yuv2rgb
RUN cmake -DCMAKE_C_COMPILER=afl-clang -DCMAKE_CXX_COMPILER=afl-clang++ .
RUN make
RUN mkdir /ppmCorpus
RUN wget https://filesamples.com/samples/image/ppm/sample_640%C3%97426.ppm
RUN mv *.ppm /ppmCorpus

ENTRYPOINT ["afl-fuzz", "-i", "/ppmCorpus", "-o", "/yuv2rgbOut"]
CMD ["/test_yuv_rgb", "rgb2yuv", "@@", "out.yuv"]
