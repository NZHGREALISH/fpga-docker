FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

# 安装基础依赖
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    make \
    cmake \
    python3 \
    python3-pip \
    wget \
    curl \
    usbutils \
    libusb-1.0-0-dev \
    tzdata \
    xz-utils \
    autoconf \
    automake \
    autotools-dev \
    curl \
    python3 \
    libmpc-dev \
    libmpfr-dev \
    libgmp-dev \
    gawk \
    bison \
    texinfo \
    gperf \
    libtool \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 从源代码构建 RISC-V 工具链
RUN git clone --recursive https://github.com/riscv-collab/riscv-gnu-toolchain.git && \
    cd riscv-gnu-toolchain && \
    ./configure --prefix=/opt/riscv \
    --enable-multilib \
    --with-arch=rv32gc \
    --with-abi=ilp32d,ilp32f,ilp32 \
    --with-cmodel=medlow \
    --enable-linux \
    --disable-gdb && \
    make -j$(nproc) && \
    make install && \
    cd .. && \
    rm -rf riscv-gnu-toolchain

# 设置环境变量
ENV PATH="/opt/riscv/bin:${PATH}"

# 创建目录结构
RUN mkdir -p /opt/intelFPGA_lite/23.1std/fpgacademy/AMP/cygwin64/home/compiler/bin

# 创建符号链接
RUN ln -s /opt/riscv/bin/riscv32-unknown-elf-gcc /opt/intelFPGA_lite/23.1std/fpgacademy/AMP/cygwin64/home/compiler/bin/ && \
    ln -s /opt/riscv/bin/riscv32-unknown-elf-objdump /opt/intelFPGA_lite/23.1std/fpgacademy/AMP/cygwin64/home/compiler/bin/ && \
    ln -s /opt/riscv/bin/riscv32-unknown-elf-nm /opt/intelFPGA_lite/23.1std/fpgacademy/AMP/cygwin64/home/compiler/bin/

# 添加启动脚本
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 设置工作目录
WORKDIR /project
RUN mkdir -p /project && chmod 777 /project

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]