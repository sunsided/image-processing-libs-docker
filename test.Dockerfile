ARG lib=scratch
ARG base=debian:bullseye

# Proxy required to use a build argument as an image name.
FROM $lib as source

# The test base to print whatever is in the library image.
FROM $base
COPY --from=source / /target
WORKDIR /target

# Kudos to https://stackoverflow.com/a/61073579/195651
CMD find . | sed -e "s/[^-][^\/]*\// |/g" -e "s/|\([^ ]\)/|-\1/"
