#fdisk is not user friendly but its a command line so it's a good idea to use it here
LFS_DISK="$1"
sudo fdisk "$LFS_DISK" <<EOF
o
n 
p 
1

+100M
a
n 
p 
2 


p 
w 
q 
EOF

#after the partitions we will make fle systems
sudo mkfs -t ext2 -F "${LFS_DISK}1"
sudo mkfs -t ext2 -F "${LFS_DISK}2"

#in the first run whole partition is mounted so to run it again unmount it again
