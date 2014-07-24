/##Compiler will insert mount commands##/c\
  # Mount /data to /root\
  echo "S10setup: mount /data partition"\
  USERDATA=ubi0:data\
  mount -t ubifs $USERDATA /root\
\
  # Mount /cache to /recovery\
  echo "S10setup: mount /cache partition"\
  CACHE=ubi0:cache\
  mount -t ubifs $CACHE /recovery
