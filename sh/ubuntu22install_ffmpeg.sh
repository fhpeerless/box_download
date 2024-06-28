#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH


#sudo mkdir -p /ffmpeg && sudo wget -N --no-check-certificate -O /ffmpeg/install_ffmpeg.sh https://raw.githubusercontent.com/fhpeerless/7X24onlinevideo/main/ffmpeg/install_ffmpeg.sh && wget -c http://www.ffmpeg.org/releases/ffmpeg-7.0 -P /ffempg && tar -zxvf /ffempg/ffmpeg-7.0.tar.gz -C /ffempg && sudo chmod -R 777 /ffmpeg && sudo bash /ffmpeg/install_ffmpeg.sh
#=================================================================#
#   System Required: CentOS7.6&ubuntu X86_64                               #
#   Description: FFmpeg Stream Media Server                       #
#   Author: 风之轻鸿                                            #
#   wx公众号: ashagw                                           #
#=================================================================#

# 颜色选择
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
font="\033[0m"

ffmpeg_install(){
# 版本查看
cat /etc/os-release
uname -a
sudo mkdir -p /ffmpeg
sudo apt install wget
wget -O /etc/apt/sources.list https://raw.githubusercontent.com/fhpeerless/ffmpeg/main/ali_sources_ubuntu22.list?token=GHSAT0AAAAAACR4P62NR5NMHIU7FTUACX34ZT4RMQQ

# 对已经安装的软件升级为最新版
apt install -y upgrade
apt install -y ffmpeg
pip3 install -y aiohttp
pip3 install aiofiles

}

stus_ffmpeg(){
ffmpeg -v

}
unstall_ffmpeg(){

sudo apt-get remove ffmpeg
sudo apt-get purge ffmpeg
sudo apt-get autoremove

}


# 开始菜单设置
echo -e "${yellow}一键安装ffmpeg。系统ubuntu22.04推流${font}"
echo -e "${red} 安装ffmpeg! ${font}"
echo -e "${green} 1.安装FFmpeg ${font}"
echo -e "${green} 2.查看FFmpeg安装状态${font}"
echo -e "${green} 3.卸载ffmpeg${font}"

start_menu(){
    read -p "请输入数字(1-4),选择你要进行的操作:" num
    case "$num" in
        1)
        ffmpeg_install
        ;;
        2)
        stus_ffmpeg
        ;;
        3)
        unstall_ffmpeg
        ;;
        4)
        stream_s4top
        ;;
	      5)
        stream_st5op
        ;;
        *)
        echo -e "${red} 请输入正确的数字 (1-5) ${font}"
        ;;
    esac
	}

# 运行开始菜单
start_menu
