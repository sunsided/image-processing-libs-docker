ARG version=0.6.3
ARG base=debian:bullseye
ARG rustversion=1.67.1
ARG rustflags="-C target-cpu=native"

# Build librav1e.
FROM $base as builder

RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update && \
  apt-get install --no-install-recommends -y \
  ca-certificates \
  build-essential curl git clang nasm pkg-config \
  libssl-dev \
  && rm -rf /var/lib/apt/lists/*

ARG rustversion
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain "$rustversion" --profile minimal
ENV PATH="/root/.cargo/bin:${PATH}"
RUN cargo install cargo-auditable cargo-c

ARG version
RUN git clone --recursive --branch "v$version" --depth 1 https://github.com/xiph/rav1e.git /rav1e/src

ARG rustflags
WORKDIR /rav1e/src/build
ENV RUSTFLAGS=${rustflags}
RUN cargo auditable cinstall --release --prefix /rav1e/lib

# Keep track of the build image.
RUN echo "$base" > /rav1e/base-image

# Assemble results.
FROM scratch
COPY --from=builder /rav1e/base-image .
COPY --from=builder /rav1e/src/LICENSE .
COPY --from=builder /rav1e/lib .

ARG version
ARG base
ARG date
ARG base
ARG rustflags

LABEL org.opencontainers.artifact.title="librav1e $version"
LABEL org.opencontainers.artifact.description="librav1e $version built from $base using RUSTFLAGS=$rustflags"
LABEL org.opencontainers.artifact.created="$date"
LABEL org.opencontainers.image.version="$version"
LABEL org.opencontainers.image.authors="Markus Mayer <sunsided@users.noreply.github.com>"
LABEL org.opencontainers.image.source="https://github.com/sunsided/imgproc-libs-docker"
LABEL org.opencontainers.image.created="$date"
