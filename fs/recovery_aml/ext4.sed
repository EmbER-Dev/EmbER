/##Compiler will insert mount commands##/c\
  # Mount /data to /root\
  echo "S10setup: mount /data partition"\
  USERDATA=/dev/data\
  mount -t ext4 $USERDATA /root
