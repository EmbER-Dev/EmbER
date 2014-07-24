/##Compiler will insert mount commands##/c\
  # Mount /data to /root\
  echo "S10setup: mount /data partition"\
  USERDATA=/dev/data\
  e2fsck -y $USERDATA\
  mount -t ext4 $USERDATA /root\
\
  # Mount /cache to /recovery\
  echo "S10setup: mount /cache partition"\
  CACHE=/dev/cache\
  e2fsck -y $CACHE\
  mount -t ext4 $CACHE /recovery
