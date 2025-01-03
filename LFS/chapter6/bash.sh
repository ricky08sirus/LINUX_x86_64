# Exit immediately if a command exits with a non-zero status
set -e

echo "Installing Bash-5.2.32..."

# Prepare Bash for compilation
./configure \
  --prefix=/usr \
  --build=$(sh support/config.guess) \
  --host=$LFS_TGT \
  --without-bash-malloc \
  bash_cv_strtold_broken=no

# Compile the package
make

# Install the package
make DESTDIR=$LFS install

# Create a symlink for sh
ln -sv bash $LFS/bin/sh

echo "Bash-5.2.32 installed successfully."
