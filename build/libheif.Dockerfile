ARG version=1.15.1
ARG base=debian:bullseye
ARG dav1d=sunsided/libdav1d:1.1.0-x64
ARG rav1e=sunsided/librav1e:0.6.3-x64
ARG de265=sunsided/libde265:1.0.11-x64

# Dependencies.
FROM $dav1d as dav1d
FROM $rav1e as rav1e
FROM $de265 as de265

# Build libheif.
FROM $base as builder

RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update && \
  apt-get install --no-install-recommends -y \
  ca-certificates pkg-config \
  cmake build-essential curl git \
  libx265-dev libturbojpeg0-dev libpng-dev \
  # libaom-dev \
  # libgdk-pixbuf2.0-dev \
  && rm -rf /var/lib/apt/lists/*

ARG version
RUN git clone --recursive --branch "v$version" --depth 1 https://github.com/strukturag/libheif.git /heif/src

COPY --from=dav1d . /dav1d
COPY --from=rav1e . /rav1e
COPY --from=de265 . /de265
ENV PKG_CONFIG_PATH /rav1e/lib/pkgconfig:/dav1d/lib/pkgconfig:/de265/lib/pkgconfig:$PKG_CONFIG_PATH

WORKDIR /heif/src/build
RUN cmake -DCMAKE_BUILD_TYPE=release \
          -DCMAKE_INSTALL_PREFIX=/heif/lib \
          -DCMAKE_PREFIX_PATH="/de265;/dav1d;/rav1e" \
          -DCMAKE_INCLUDE_PATH="/rav1e/include/rav1e" \
          -DWITH_LIBDE265=on \
          -DWITH_DAV1D=on \
          -DWITH_RAV1E=on \
          -DWITH_X265=on \
          -DWITH_AOM_ENCODER=off \
          -DWITH_AOM_DECODER=off \
          -DWITH_SvtEnc=off \
          -DWITH_EXAMPLES=off -DWITH_DEFLATE_HEADER_COMPRESSION=on \
          -DENABLE_MULTITHREADING_SUPPORT=on \
          -DENABLE_PARALLEL_TILE_DECODING=on \
          ..
RUN make -j4 && make install

# Keep track of the build image.
RUN echo "$base" > /heif/base-image

# Assemble results.
FROM scratch
COPY --from=builder /heif/base-image .
COPY --from=builder /heif/src/COPYING .
COPY --from=builder /heif/lib .

ARG version
ARG base
ARG date
ARG base

LABEL org.opencontainers.artifact.title="libheif $version"
LABEL org.opencontainers.artifact.description="libheif $version built from $base"
LABEL org.opencontainers.artifact.created="$date"
LABEL org.opencontainers.image.version="$version"
LABEL org.opencontainers.image.authors="Markus Mayer <sunsided@users.noreply.github.com>"
LABEL org.opencontainers.image.source="https://github.com/sunsided/imgproc-libs-docker"
LABEL org.opencontainers.image.created="$date"
