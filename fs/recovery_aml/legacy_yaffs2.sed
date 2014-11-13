/##Compiler will insert mount commands##/c\
  # Find /userdata via mtd partition name\
  echo "S10setup: find /data partition"\
  for i in `ls /dev/mtd* | grep -o "mtd[0-9]$"`; do\
    if [[ "`cat /sys/devices/virtual/mtd/$i/name`" == "userdata" ]]; then\
      USERDATA="/dev/"`ls /sys/devices/virtual/mtd/$i | grep -o mtdblock[0-9]`\
      break\
    fi\
  done\
\
  # Find /cache via mtd partition name\
  echo "S10setup: find /cache partition"\
  for i in `ls /dev/mtd* | grep -o "mtd[0-9]$"`; do\
    if [[ "`cat /sys/devices/virtual/mtd/$i/name`" == "cache" ]]; then\
      CACHE="/dev/"`ls /sys/devices/virtual/mtd/$i | grep -o mtdblock[0-9]`\
      break\
    fi\
  done\
\
  # Mount /data to /root\
  echo "S10setup: mount /data partition"\
  mount -t yaffs2 $USERDATA /root\
\
  # Mount /cache to /recovery\
  echo "S10setup: mount /cache partition"\
  mount -t yaffs2 $CACHE /recovery
