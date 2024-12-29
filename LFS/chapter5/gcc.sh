#!/bin/bash

# Set some basic variables
MPFR_VERSION="mpfr-4.2.1"
GMP_VERSION="gmp-6.3.0"
MPC_VERSION="mpc-1.3.1"
GCC_VERSION="gcc-12.3.0" # Modify this based on the version you're building

# Extract archives
echo "Extracting MPFR..."
tar -xf ../$MPFR_VERSION.tar.xz
mv -v $MPFR_VERSION mpfr

echo "Extracting GMP..."
tar -xf ../$GMP_VERSION.tar.xz
mv -v $GMP_VERSION gmp

echo "Extracting MPC..."
tar -xf ../$MPC_VERSION.tar.gz
mv -v $MPC_VERSION mpc

# Set directory for 64-bit libraries if on x86_64 architecture
case $(uname -m) in
x86_64)
  echo "Modifying GCC config for 64-bit architecture..."
  sed -e '/m64=/s/lib64/lib/' \
    -i.orig gcc/config/i386/t-linux64
  ;;
*)
  echo "Not on x86_64 architecture, skipping modifications."
  ;;
esac

# Create a dedicated build directory and enter it
echo "Creating build directory..."
mkdir -v build
cd build

# Configure GCC with desired options
echo "Configuring GCC..."
../configure \
  --target=$LFS_TGT \
  --prefix=$LFS/tools \
  --with-glibc-version=2.40 \
  --with-sysroot=$LFS \
  --with-newlib \
  --without-headers \
  --enable-default-pie \
  --enable-default-ssp \
  --disable-nls \
  --disable-shared \
  --disable-multilib \
  --disable-threads \
  --disable-libatomic \
  --disable-libgomp \
  --disable-libquadmath \
  --disable-libssp \
  --disable-libvtv \
  --disable-libstdcxx \
  --enable-languages=c,c++

# Build GCC
echo "Building GCC..."
make

# Install GCC
echo "Installing GCC..."
make install

# Go back to the root directory
cd ..

# Update the limits.h header file
echo "Updating limits.h..."
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
  $(dirname $($LFS_TGT-gcc -print-libgcc-file-name))/include/limits.h

echo "GCC build and installation complete!"
