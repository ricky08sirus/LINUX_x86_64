# Exit immediately if a command exits with a non-zero status
set -e

echo "Installing Ncurses-6.5..."

# Ensure that gawk is used instead of mawk
sed -i s/mawk// configure

# Create a build directory and build the "tic" program
mkdir build
pushd build
../configure
make -C include
make -C progs tic
popd

# Configure Ncurses for compilation
./configure \
  --prefix=/usr \
  --host=$LFS_TGT \
  --build=$(./config.guess) \
  --mandir=/usr/share/man \
  --with-manpage-format=normal \
  --with-shared \
  --without-normal \
  --with-cxx-shared \
  --without-debug \
  --without-ada \
  --disable-stripping

# Compile the package
make

# Install the package
make DESTDIR=$LFS TIC_PATH=$(pwd)/build/progs/tic install

# Create the symlink for libncurses
ln -sv libncursesw.so $LFS/usr/lib/libncurses.so

# Modify curses.h for wide-character compatibility
sed -e 's/^#if.*XOPEN.*$/#if 1/' -i $LFS/usr/include/curses.h

echo "Ncurses-6.5 installed successfully."
