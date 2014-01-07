/##Compiler will insert mount commands##/c\
  # Mount /data to /root\
  echo "S10setup: mount /data partition"\
  USERDATA=ubi0:data\
  mount -t ubifs $USERDATA /root
