# Image Processing Library Builds

Scripts and Dockerfiles to simplify building of image processing libraries
such as [libheif], [libdav1d], [librav1e] etc.

Multi-stage builds are used to build the library using current
system settings. Afterwards a `scratch` image is created and
the build artifacts are copied to it.

Builds are currently based on `debian:bullseye`.

## Using the prebuilt libraries

To use a prebuilt library, use a `COPY --from=image` step in
your docker build, e.g. like so:

```docker
COPY --from=sunside/libdav1d:1.1.0-x64 /lib/ /usr/lib/x86_64-linux-gnu/
```

The `.env` file contains configuration for all build scripts.
If you need to rebuild the libraries under different conditions,
make sure to adjust this file to your needs:

```bash
BASE_IMAGE=debian:bullseye
DOCKER_REGISTRY=sunside/
```

## Helper scripts

Two helper scripts exist:

- `list-image-contents.sh` lists the contents of the created scratch image
- `extract-image-contents.sh` extracts the files from the scratch image and bundles it up in a `.tar.gz` file.

```shell
./list-image-contents.sh sunside/libdav1d:1.1.0-x64
./extract-image-contents.sh sunside/libdav1d:1.1.0-x64
```

# Libraries

## [libdav1d] (👉 [libdav1d.Dockerfile](libdav1d.Dockerfile))

To produce `sunside/libdav1d:1.1.0-x64` ([Docker Hub](https://hub.docker.com/repository/docker/sunside/libdav1d)), run:

```shell
./build-dav1d.sh
```

This builds `libdav1d` as both a shared object and static archive.

<details>
    <summary>Output</summary>

```
.
 |-lib
 | |-x86_64-linux-gnu
 | | |-libdav1d.so
 | | |-libdav1d.so.6
 | | |-libdav1d.so.6.8.0
 | | |-libdav1d.a
 | | |-pkgconfig
 | | | |-dav1d.pc
 |-base-image
 |-COPYING
 |-include
 | |-dav1d
 | | |-data.h
 | | |-picture.h
 | | |-common.h
 | | |-headers.h
 | | |-version.h
 | | |-meson.build
 | | |-dav1d.h
 | | |-version.h.in

```

</details>

## [libde265] (👉 [libde265.Dockerfile](libde265.Dockerfile))

To produce `sunside/libde265:1.0.11-x64` ([Docker Hub](https://hub.docker.com/repository/docker/sunside/libde265)), run:

```shell
./build-de265.sh
```

This builds `libde265` as a shared object.

<details>
    <summary>Output</summary>

```
.
 |-lib
 | |-cmake
 | | |-libde265
 | | | |-libde265Config-release.cmake
 | | | |-libde265ConfigVersion.cmake
 | | | |-libde265Config.cmake
 | |-pkgconfig
 | | |-libde265.pc
 | |-libde265.so
 |-base-image
 |-COPYING
 |-include
 | |-libde265
 | | |-en265.h
 | | |-de265-version.h
 | | |-de265.h
```

</details>

## [librav1e] (👉 [librav1e.Dockerfile](librav1e.Dockerfile))

To produce `sunside/librav1e:0.6.3-x64` ([Docker Hub](https://hub.docker.com/repository/docker/sunside/librav1e)), run:

```shell
./build-rav1e.sh
```

This builds `librav1e` as both a shared object and a static archive.

<details>
    <summary>Output</summary>

```
.
 |-lib
 | |-librav1e.a
 | |-librav1e.so
 | |-librav1e.so.0.6.3
 | |-pkgconfig
 | | |-rav1e.pc
 | |-librav1e.so.0
 |-base-image
 |-include
 | |-rav1e
 | | |-rav1e.h
 |-LICENSE
```

</details>


## [libheif] (👉 [libheif.Dockerfile](libheif.Dockerfile))

This build depends on `libde265`, `librav1e` and `libdav1d` built above.
See [build-heif.sh](build-heif.sh) for the specific versions.

To produce `sunside/libheif:1.1.0-x64` ([Docker Hub](https://hub.docker.com/repository/docker/sunside/libheif)), run:

```shell
./build-heif.sh
```

This builds `libheif` as a shared object.

<details>
    <summary>Output</summary>

```
.
 |-lib
 | |-libheif.so.1
 | |-cmake
 | | |-libheif
 | | | |-libheif-config-release.cmake
 | | | |-libheif-config.cmake
 | | | |-libheif-config-version.cmake
 | |-libheif.so.1.15.1
 | |-libheif.so
 | |-libheif
 | | |-libheif-rav1e.so
 | |-pkgconfig
 | | |-libheif.pc
 |-share
 | |-thumbnailers
 | | |-heif.thumbnailer
 |-base-image
 |-COPYING
 |-include
 | |-libheif
 | | |-heif.h
 | | |-heif_version.h
 | | |-heif_cxx.h
 | | |-heif_plugin.h
```

</details>

[libdav1d]: https://code.videolan.org/videolan/dav1d
[libde265]: https://github.com/strukturag/libde265
[libheif]: https://github.com/strukturag/libheif
[librav1e]: https://github.com/xiph/rav1e
