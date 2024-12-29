mkdir -v build
cd build

../libstdc++-v3/configure \
  --host=$LFS_TGT \
  --build=$(../config.guess) \
  --prefix=/usr \
  --disable-multilib \
  --disable-nls \
  --disable-libstdc++-pch \
  --with-g++-include-dir=/tools/$LFS_TGT/include/c++/$VERSION &&
  make &&
  make DESTDIR=$LFS install
