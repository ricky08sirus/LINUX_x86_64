./configure --prefix=/usr \
  --without-guile \
  --host=$LFS_TGT \
  --build=$(build-aux/config.guess)

make

make DESTDIR=$LFS install

$LFS/usr/bin/make --version
