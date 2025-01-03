# Exit immediately if a command exits with a non-zero status
set -e

echo "Installing File-5.45..."

# Step 1: Make a temporary copy of the file command for the build host
echo "Creating temporary build environment for File..."
mkdir build
pushd build

../configure \
  --disable-bzlib \
  --disable-libseccomp \
  --disable-xzlib \
  --disable-zlib

make
popd

# Step 2: Prepare File for compilation
echo "Configuring File for cross-compilation..."
./configure \
  --prefix=/usr \
  --host=$LFS_TGT \
  --build=$(./config.guess)

# Step 3: Compile the package
echo "Compiling File package..."
make FILE_COMPILE=$(pwd)/build/src/file

# Step 4: Install the package
echo "Installing File package..."
make DESTDIR=$LFS install

# Step 5: Remove the libtool archive file
echo "Removing harmful libtool archive file..."
rm -v $LFS/usr/lib/libmagic.la

echo "File-5.45 installed successfully."
