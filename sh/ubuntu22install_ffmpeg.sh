#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH


#sudo mkdir -p /ffmpeg && sudo wget -N --no-check-certificate -O /ffmpeg/install_ffmpeg.sh https://raw.githubusercontent.com/fhpeerless/7X24onlinevideo/main/ffmpeg/install_ffmpeg.sh && wget -c http://www.ffmpeg.org/releases/ffmpeg-7.0 -P /ffempg && tar -zxvf /ffempg/ffmpeg-7.0.tar.gz -C /ffempg && sudo chmod -R 777 /ffmpeg && sudo bash /ffmpeg/install_ffmpeg.sh
#=================================================================#
#   System Required: ubuntu X86_64                               #
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
# 尝试获取Python 3的版本
PYTHON_VERSION=$(python3 --version 2>&1)
# 检查命令是否成功执行
if [[ $PYTHON_VERSION == Python\ 3* ]]; then
    echo "Python 3 is installed. Version: $PYTHON_VERSION"
else
    echo "Python 3 is not installed."
    # 退出脚本
    exit 0
fi


sudo apt update

cat /etc/os-release
uname -a
sudo mkdir -p /ffmpeg
sudo apt install wget
sudo wget -O /etc/apt/sources.list https://raw.githubusercontent.com/fhpeerless/box_download/main/sh/ali_sources_ubuntu22.list

sudo apt update
apt install -y upgrade
apt install -y ffmpeg
sudo apt install -y python3-pip
pip3 install aiohttp
pip3 install aiofiles

}

stus_ffmpeg(){
ffmpeg -version
}

unstall_ffmpeg(){
sudo apt-get remove ffmpeg
sudo apt-get purge ffmpeg
sudo apt-get autoremove
sudo apt remove python3-pip
}


install_python3(){

sudo apt install python3

}
uninstall_pipd(){
   pip3 uninstall aiohttp
   pip3 uninstall aiofiles
}

# 开始菜单设置
echo -e "${yellow}一键安装ffmpeg。系统ubuntu22.04推流${font}"
echo -e "${red} 安装ffmpeg! ${font}"
echo -e "${green} 1.安装FFmpeg ${font}"
echo -e "${green} 2.查看FFmpeg安装状态${font}"
echo -e "${green} 3.卸载ffmpeg${font}"
echo -e "${green} 4.安装python3${font}"
echo -e "${green} 5.卸载python3的各个依赖${font}"

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
        install_python3
        ;;
	5)
        uninstall_pipd
        ;;
        *)
        echo -e "${red} 请输入正确的数字 (1-5) ${font}"
        ;;
    esac
	}

# 运行开始菜单
start_menu
