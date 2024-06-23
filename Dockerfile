FROM ubuntu:22.04

# 安装基本工具和依赖
RUN apt-get update && apt-get install -y \
    build-essential \
    pkg-config \
    git \
    curl \
    cmake \
    ninja-build \
    meson \
    yasm \
    nasm \
    libtool \
    autoconf \
    automake \
    texinfo \
    zlib1g-dev \
    gcc-aarch64-linux-gnu \
    g++-aarch64-linux-gnu \
    libfdk-aac-dev \
    libmp3lame-dev \
    libopus-dev \
    libvpx-dev \
    libx264-dev \
    libx265-dev \
    libdrm-dev \
    libssl-dev \
    libmediainfo-dev \
    openjdk-8-jdk

# 设置工作目录
WORKDIR /workspace

# 克隆 FFmpeg 源代码
RUN git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg && \
    cd ffmpeg && \
    git checkout n6.1.1

# 配置和编译 FFmpeg
WORKDIR /workspace/ffmpeg
RUN ./configure \
      --arch=arm64 \
      --enable-cross-compile \
      --cross-prefix=aarch64-linux-gnu- \
      --target-os=linux \
      --enable-gpl \
      --enable-nonfree \
      --enable-libfdk-aac \
      --enable-libmp3lame \
      --enable-libopus \
      --enable-libvpx \
      --enable-libx264 \
      --enable-libx265 \
      --enable-mediacodec \
      --enable-static \
      --disable-shared \
      --disable-debug \
      --extra-cflags="-I/usr/aarch64-linux-gnu/include" \
      --extra-ldflags="-L/usr/aarch64-linux-gnu/lib" && \
    make -j$(nproc) && \
    make install

# 复制可执行文件
RUN cp /workspace/ffmpeg/ffmpeg /output/ffmpeg

# 设置输出目录
VOLUME /output
