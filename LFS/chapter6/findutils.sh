# Exit immediately if a command exits with a non-zero status
set -e

echo "Installing Findutils-4.10.0..."

# Step 1: Configure Findutils for compilation
echo "Configuring Findutils..."
./configure \
  --prefix=/usr \
  --localstatedir=/var/lib/locate \
  --host=$LFS_TGT \
  --build=$(build-aux/config.guess)

# Step 2: Compile the package
echo "Compiling Findutils..."
make

# Step 3: Install the package
echo "Installing Findutils..."
make DESTDIR=$LFS install

echo "Findutils-4.10.0 installed successfully."
