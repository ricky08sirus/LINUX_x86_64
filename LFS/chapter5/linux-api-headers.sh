set -e

# Define the Linux version and LFS directory
KERNEL_VERSION="6.10.5"
LFS=${LFS:-/mnt/lfs}

# Extract the source tarball
tar -xf linux-$KERNEL_VERSION.tar.xz
cd linux-$KERNEL_VERSION

# Clean the source tree

make mrproper

# Build and sanitize headers
make headers
find usr/include -type f ! -name '*.h' -delete

# Install the headers
cp -rv usr/include $LFS/usr

# Verify installation
echo "Headers installed to $LFS/usr/include"
ls -R $LFS/usr/include
