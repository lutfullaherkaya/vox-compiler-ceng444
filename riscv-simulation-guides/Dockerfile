# syntax=docker/dockerfile:1
FROM ubuntu:22.04
RUN apt update
RUN apt install -y device-tree-compiler git wget tar build-essential libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev ninja-build python3 autoconf automake autotools-dev curl python3 libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev
ENV RISCV="/opt/riscv/"
ENV PATH="${PATH}:${RISCV}bin/:${RISCV}riscv64-unknown-linux-gnu/bin/"
WORKDIR /riscv_tool_src
RUN git clone https://github.com/riscv-software-src/riscv-pk
RUN git clone https://github.com/riscv-software-src/riscv-isa-sim
RUN git clone https://github.com/riscv/riscv-gnu-toolchain
RUN wget -q https://download.qemu.org/qemu-7.2.0-rc4.tar.xz
RUN tar -xf qemu-7.2.0-rc4.tar.xz
WORKDIR /riscv_tool_src/riscv-isa-sim/build
RUN ../configure --prefix=$RISCV
RUN make
RUN make install
WORKDIR /riscv_tool_src/riscv-gnu-toolchain/build
RUN ../configure --prefix=$RISCV
RUN make linux
WORKDIR /riscv_tool_src/riscv-pk/build
RUN ../configure --prefix=$RISCV --host=riscv64-unknown-linux-gnu
RUN make
RUN make install
WORKDIR /riscv_tool_src/qemu-7.2.0-rc4/build
RUN ../configure --target-list=riscv64-linux-user
RUN make
RUN make install
WORKDIR /examples
COPY hello.c /examples/
COPY strveccpy.s /examples/
RUN riscv64-unknown-linux-gnu-gcc -march=rv64gcv -static hello.c strveccpy.s -o hello
RUN spike --isa=RV64IMAFDCV $(which pk) hello
RUN qemu-riscv64 -cpu rv64,v=true,zba=true,vlen=128,vext_spec=v1.0 hello
