./configure --prefix=/usr --host=$LFS_TGT

make
make DESTDIR=$LFS install
$LFS/usr/bin/gzip --version
