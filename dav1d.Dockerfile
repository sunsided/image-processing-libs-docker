ARG version=1.1.0
ARG base=debian:bullseye

# Build libdav1d.
FROM $base as builder

RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update && \
  apt-get install --no-install-recommends -y \
  ca-certificates \
  nasm automake build-essential curl git \
  python3-pip ninja-build pkg-config \
  && rm -rf /var/lib/apt/lists/*
RUN pip3 install meson

ARG version
RUN git clone  --recursive --branch "$version" --depth 1 https://code.videolan.org/videolan/dav1d.git /dav1d/src

WORKDIR /dav1d/src/build
RUN meson setup --buildtype=release --strip --prefix=/dav1d --libdir=lib --default-library=both ..
RUN ninja && ninja install

# Keep track of the build image.
RUN echo "$base" > /dav1d/base-image

# Assemble results.
FROM scratch
COPY --from=builder /dav1d/base-image .
COPY --from=builder /dav1d/src/COPYING .
COPY --from=builder /dav1d/lib lib
