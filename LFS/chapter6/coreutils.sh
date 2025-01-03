# Exit immediately if a command exits with a non-zero status
set -e

echo "Installing Coreutils-9.5..."

# Prepare Coreutils for compilation
./configure \
  --prefix=/usr \
  --host=$LFS_TGT \
  --build=$(build-aux/config.guess) \
  --enable-install-program=hostname \
  --enable-no-install-program=kill,uptime

# Compile the package
make

# Install the package
make DESTDIR=$LFS install

# Move programs to their final expected locations
mv -v $LFS/usr/bin/chroot $LFS/usr/sbin
mkdir -pv $LFS/usr/share/man/man8
mv -v $LFS/usr/share/man/man1/chroot.1 $LFS/usr/share/man/man8/chroot.8

# Update the section number in the manual page
sed -i 's/"1"/"8"/' $LFS/usr/share/man/man8/chroot.8

echo "Coreutils-9.5 installed successfully."
