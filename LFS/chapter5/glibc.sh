#!/bin/bash

# Glibc version and required files
GLIBC_VERSION="glibc-2.40"
GLIBC_PATCH="glibc-2.40-fhs-1.patch" # Modify if the patch has a different name

# Create symbolic links for LSB compliance based on architecture
case $(uname -m) in
i?86)
  echo "Creating symbolic link for i386 architecture..."
  ln -sfv ld-linux.so.2 $LFS/lib/ld-lsb.so.3
  ;;
x86_64)
  echo "Creating symbolic links for x86_64 architecture..."
  ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64
  ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64/ld-lsb-x86-64.so.3
  ;;
*)
  echo "Unsupported architecture: $(uname -m)"
  exit 1
  ;;
esac

# Apply the patch for FHS compliance
echo "Applying patch..."
patch -Np1 -i ../$GLIBC_PATCH

# Create build directory and enter it
echo "Creating build directory..."
mkdir -v build
cd build

# Configure Glibc build
echo "Configuring Glibc..."
echo "rootsbindir=/usr/sbin" >configparms

../configure \
  --prefix=/usr \
  --host=$LFS_TGT \
  --build=$(../scripts/config.guess) \
  --enable-kernel=4.19 \
  --with-headers=$LFS/usr/include \
  --disable-nscd \
  libc_cv_slibdir=/usr/lib

# Build and install Glibc
echo "Building Glibc..."
make

echo "Installing Glibc..."
make DESTDIR=$LFS install

# Fix the ldd script after installation
echo "Fixing ldd script..."
sed '/RTLDLIST=/s@/usr@@g' -i $LFS/usr/bin/ldd

echo "Glibc build and installation complete!"
echo 'int main(){}' | $LFS_TGT-gcc -xc -
rm -v a.out
