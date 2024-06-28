import asyncio
import subprocess
import logging
import os
import time
import aiohttp
from datetime import datetime

gcc = 1  # 设置变量gcc为1

if gcc == 1:
    logging.disable(logging.INFO) # 如果gcc等于1，则禁用INFO级别的日志记录

# 设置日志记录器
logging.basicConfig(filename='script.log', level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def is_next_spot(danmu):
    if danmu == "下一个景点":
        return True
    else:
        return False

headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36'
}

async def get_danmu():
    url = 'https://api.live.bilibili.com/xlive/web-room/v1/dM/gethistory?roomid=1702917135&room_type=0'
    async with aiohttp.ClientSession() as session:
        async with session.get(url, headers=headers) as response:
            data_json = await response.json()
            return data_json.get('data', {}).get('room', [])

async def check_danmu():
    check_time = time.time()  # 当前系统时间戳
    start_time = time.time()  # 记录循环开始的时间
    while True:
        dm_list = await get_danmu()

        for index in dm_list:
            # 对于dm_list列表中的每个元素，将其依次赋值给变量index
            # convert danmu timeline to timestamp
            timeline=index['timeline']
            timeline = datetime.strptime(timeline, '%Y-%m-%d %H:%M:%S') # 把表示时间的字符串，转换为时间类型的变量
            timeline_stamp = time.mktime(timeline.timetuple()) # 首先把时间对象转换为一个结构体，然后把结构体转换为一个linux系统时间戳
            
            # Check if the danmu is after our last check
            if timeline_stamp <= check_time:
                continue

            nickname=index['nickname'] # 获取对应的键值并赋值给ncikname
            text=index['text']
            isNextSpot = is_next_spot(text)  
            
            if isNextSpot:                   
                dm_dict={
                    '昵称':nickname,
                    '时间':timeline,
                    '弹幕':text,
                    '是否是下一个景点':  isNextSpot
                }
                print(dm_dict)
                return True

        # 检查是否已经过去了10分钟
        if time.time() - start_time >= 10 * 60:
            return True

        await asyncio.sleep(3)

async def clear_log(filename):
    # 检查文件大小
    if os.path.exists(filename) and os.path.getsize(filename) > 1048576:  # 文件大小超过1MB
        with open(filename, 'w'):
            pass  # 打开文件并立即关闭，实现清空文件内容
    # await asyncio.sleep(10 * 60)  # 您可能不需要这行，除非您希望函数在完成操作后等待一段时间
        
# 异步执行 FFmpeg 推流
async def stream_ffmpeg(m3u8_url, rtmp_url):
    cmd = [
        'ffmpeg',
        '-user_agent', 'Mozilla/5.0',
        '-re',
        '-i', m3u8_url,
        '-c:v', 'copy',
        '-c:a', 'aac',
        '-b:a', '128k',
        '-f', 'flv', rtmp_url
    ]
    # 如果gcc等于1，则将stdout和stderr重定向到/dev/null
    if gcc == 1:
        cmd += ['-loglevel', 'quiet']  # 降低日志级别以减少输出

    proc = await asyncio.create_subprocess_exec(
        *cmd,
        stdout=(None if gcc == 1 else asyncio.subprocess.PIPE),
        stderr=(None if gcc == 1 else asyncio.subprocess.STDOUT)  # 根据gcc的值决定是否合并stderr与stdout
    )

    # 异步读取ffmpeg输出并写入日志
    async def log_output(stream):
        while True:
            line = await stream.readline()
            if not line: 
                break
            logging.info(line.decode().strip())

    # 创建异步任务来读取输出
    if gcc != 1:
        asyncio.create_task(log_output(proc.stdout))
 
    await check_danmu()# 在事件循环中运行check_danmu函数
    
    if gcc != 1:
        logging.info("结束 FFmpeg 推流")
    proc.terminate()
    await proc.wait()

async def kill_ffmpeg():
    if gcc != 1:
        logging.info("开始强杀所有ffmpeg进程")
    kill_cmd = ['killall', '-9', 'ffmpeg']
    proc = await asyncio.create_subprocess_exec(
        *kill_cmd,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE
    )
    await proc.wait()
    if gcc != 1:
        asyncio.create_task(clear_log('/ffmpeg/script.log'))  # 清理日志

def read_m3u8_url_from_file(file_path):
    line_number = 0
    # 从另一个文件读取当前行数
    try:
        with open('line_number.txt', 'r') as f:
            line_number = int(f.read().strip())
    except FileNotFoundError:
        pass  # 如果文件不存在，从第一行开始读取

    with open(file_path, 'r') as file:
        lines = file.readlines()
        url = lines[line_number].strip()  # 获取当前行的URL
        line_number = (line_number + 1) % len(lines)  # 更新行号，轮回到文件开始

    # 更新行数文件
    with open('line_number.txt', 'w') as f:
        f.write(str(line_number))
        f.flush()  # 强制刷新缓冲区，确保数据被写入文件

    return url

# 主函数
async def main():
    rtmp_key = "?streamname=live_585038005_20097601&key=344982c23f2a5f6e2129d98d2b1f8f46&schedule=rtmp&pflag=1"
    rtmp_base_url = "rtmp://live-push.bilivideo.com/live-bvc/"
    rtmp_url = f"{rtmp_base_url}{rtmp_key}"

    while True:
        m3u8_url = read_m3u8_url_from_file('source_video.txt')
        print(f"开始处理 {m3u8_url}")
        await stream_ffmpeg(m3u8_url, rtmp_url)

        print("强杀所有ffmpeg进程...")
       # await kill_ffmpeg()

# 运行主函数
if __name__ == '__main__':
    asyncio.run(main())