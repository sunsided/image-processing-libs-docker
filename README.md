# Image Processing Library Builds

Scripts and Dockerfiles to simplify building of image processing libraries
such as [libdav1d].

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

## [libdav1d] (👉 [dav1d.Dockerfile](dav1d.Dockerfile))

To produce `sunside/libdav1d:1.1.0-x64`, run:

```shell
./build-dav1d.sh
```

This builds `libdav1d` both as a shared object and static archive.

<details>
    <summary>Output</summary>

```
 |-lib
 | |-libdav1d.so
 | |-libdav1d.so.6
 | |-libdav1d.so.6.8.0
 | |-libdav1d.a
 | |-pkgconfig
 | | |-dav1d.pc
 |-base-image
 |-COPYING
```

</details>


[libdav1d]: https://code.videolan.org/videolan/dav1d
