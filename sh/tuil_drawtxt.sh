#!/bin/bash

#运行没问题


export PATH="/usr/local/ffmpeg/bin:$PATH"


read -p "输入你的推流地址和推流码(rtmp协议): " rtmp

SOURCE_FILE=/onlinevideo/source_video.txt

while true; do

mapfile -t SOURCE_URLS < "$SOURCE_FILE"


# 遍历数组
for SOURCE_URL in "${SOURCE_URLS[@]}"; do
 echo "当前直播源${SOURCE_URL}"
    


nohup ffmpeg -user_agent "Mozilla/5.0" -re -i "$SOURCE_URL" -vf "drawtext=fontfile=/onlinevideo/jtz.ttf:textfile=/onlinevideo/gundong.txt:fontcolor=black:fontsize=44:x=w-mod(t*100\\,w+tw):y=10, drawtext=fontfile=/onlinevideo/jtz.ttf: text='当前时间%{localtime}': fontcolor=black: fontsize=44: x=10: y=h-th-25" -c:v libx264 -b:v 1000k -c:a aac -b:a 128k -f flv "${rtmp}" &

    sleep 100

    pkill -9 ffmpeg
    sleep 1
# 检查 ffmpeg 进程是否仍然存在，如果存在，再使用 SIGKILL
    pgrep ffmpeg && pkill -9 ffmpeg
    sleep 2

  done


done