/##Compiler will insert mount commands##/c\
  # Mount /data to /root\
  echo "S10setup: mount /data partition"\
  USERDATA=/dev/data\
  e2fsck -y $USERDATA\
  mount -t ext4 $USERDATA /root
