ARG version=1.0.11
ARG base=debian:bullseye

# Build libde265.
FROM $base as builder

RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update && \
  apt-get install --no-install-recommends -y \
  ca-certificates pkg-config \
  cmake build-essential curl git \
  && rm -rf /var/lib/apt/lists/*

ARG version
RUN git clone --recursive --branch "v$version" --depth 1 https://github.com/strukturag/libde265.git /de265/src

WORKDIR /de265/src/build
RUN cmake -DCMAKE_BUILD_TYPE=release -DCMAKE_INSTALL_PREFIX=/de265/lib -DENABLE_DECODER=off -DENABLE_ENCODER=off ..
RUN make -j4 && make install

# Keep track of the build image.
RUN echo "$base" > /de265/base-image

# Assemble results.
FROM scratch
COPY --from=builder /de265/base-image .
COPY --from=builder /de265/src/COPYING .
COPY --from=builder /de265/lib .

ARG version
ARG base
ARG date
ARG base

LABEL org.opencontainers.artifact.title="libde265 $version"
LABEL org.opencontainers.artifact.description="libde265 $version built from $base"
LABEL org.opencontainers.artifact.created="$date"
LABEL org.opencontainers.image.version="$version"
LABEL org.opencontainers.image.authors="Markus Mayer <sunsided@users.noreply.github.com>"
LABEL org.opencontainers.image.source="https://github.com/sunsided/imgproc-libs-docker"
LABEL org.opencontainers.image.created="$date"
