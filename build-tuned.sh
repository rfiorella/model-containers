#!/bin/bash
# Build script for architecture-tuned containers
#
# Usage:
#   ./build-tuned.sh                    # debug build with -g -fPIC
#   ./build-tuned.sh v3-znver1          # AVX2+FMA, optimized for AMD Zen1
#   ./build-tuned.sh v4-znver4          # AVX-512, optimized for AMD Zen4
#   ./build-tuned.sh apple-m-series     # ARM, optimized for Apple M-series

set -e

VARIANT="${1:-debug}"

case "$VARIANT" in
    debug)
        ARCH_FLAGS="-g -fPIC"
        TAG_SUFFIX="-debug"
        echo "Building debug variant with symbols"
        ;;
    v3-znver1)
        ARCH_FLAGS="-march=x86-64-v3 -mtune=znver1"
        TAG_SUFFIX="-v3-znver1"
        echo "Building for x86-64-v3 optimized for AMD Zen1"
        echo "⚠️  Warning: This image requires AVX2+FMA support"
        ;;
    v4-znver4)
        ARCH_FLAGS="-march=x86-64-v4 -mtune=znver4"
        TAG_SUFFIX="-v4-znver4"
        echo "Building for x86-64-v4 optimized for AMD Zen4"
        echo "⚠️  Warning: This image requires AVX-512 support"
        ;;
    apple-m-series)
        ARCH_FLAGS="-mcpu=apple-m1"
        TAG_SUFFIX="-apple-m-series"
        echo "Building for Apple M-series (ARM)"
        echo "⚠️  Warning: This is an ARM image"
        ;;
    *)
        echo "Unknown variant: $VARIANT"
        echo "Valid options: debug, v3-znver1, v4-znver4, apple-m-series"
        exit 1
        ;;
esac

echo ""
echo "=== Building base-ubuntu${TAG_SUFFIX} ==="
docker build \
    --build-arg ARCH_FLAGS="${ARCH_FLAGS}" \
    --build-arg mpi_flavor=openmpi \
    --build-arg mpi_version=4.1.7 \
    -f base-ubuntu/Dockerfile.tuned \
    -t rfiorella/model-containers:base-ubuntu${TAG_SUFFIX} \
    ./base-ubuntu

echo ""
echo "=== Building e3sm-dev${TAG_SUFFIX} ==="
docker build \
    --build-arg BASE_TAG="base-ubuntu${TAG_SUFFIX}" \
    -f e3sm-dev/Dockerfile \
    -t rfiorella/model-containers:e3sm-dev${TAG_SUFFIX} \
    .

echo ""
echo "✅ Build complete!"
echo ""
echo "Images created:"
echo "  - rfiorella/model-containers:base-ubuntu${TAG_SUFFIX}"
echo "  - rfiorella/model-containers:e3sm-dev${TAG_SUFFIX}"
echo ""
echo "To verify the image works on your target hardware:"
echo "  docker run --rm rfiorella/model-containers:e3sm-dev${TAG_SUFFIX} gcc -march=native -Q --help=target | grep march"
