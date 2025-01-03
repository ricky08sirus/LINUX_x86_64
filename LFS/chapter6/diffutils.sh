# Exit immediately if a command exits with a non-zero status
set -e

echo "Installing Diffutils-3.10..."

# Prepare Diffutils for compilation
./configure \
  --prefix=/usr \
  --host=$LFS_TGT \
  --build=$(./build-aux/config.guess)

# Compile the package
make

# Install the package
make DESTDIR=$LFS install

echo "Diffutils-3.10 installed successfully."
