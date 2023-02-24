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
RUN git clone --recursive --branch "$version" --depth 1 https://code.videolan.org/videolan/dav1d.git /dav1d/src

WORKDIR /dav1d/src/build
RUN meson setup --buildtype=release --strip --prefix=/dav1d --default-library=both -Denable_tools=false -Denable_examples=false -Denable_tests=false ..
RUN ninja && ninja install

# Headers are not automatically dispatched.
RUN mkdir -p /dav1d/include/dav1d
RUN cp -r /dav1d/src/include/dav1d /dav1d/include/

# Keep track of the build image.
RUN echo "$base" > /dav1d/base-image

# Assemble results.build/
FROM scratch
COPY --from=builder /dav1d/base-image .
COPY --from=builder /dav1d/src/COPYING .
COPY --from=builder /dav1d/lib lib
COPY --from=builder /dav1d/include include

ARG version
ARG base
ARG date
ARG base

LABEL org.opencontainers.artifact.title="libdav1d $version"
LABEL org.opencontainers.artifact.description="libdav1d $version built from $base"
LABEL org.opencontainers.artifact.created="$date"
LABEL org.opencontainers.image.version="$version"
LABEL org.opencontainers.image.authors="Markus Mayer <sunsided@users.noreply.github.com>"
LABEL org.opencontainers.image.source="https://github.com/sunsided/imgproc-libs-docker"
LABEL org.opencontainers.image.created="$date"
