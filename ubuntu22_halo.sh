#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
ffmpeg_install(){
# 禁止非系统进程开机自启
禁止进程开机自启的方法取决于这些进程是如何被配置为自启的。常见的几种自启配置方法包括但不限于：
Systemd 服务：对于使用 systemd 的系统，您可以使用以下命令禁用服务：

sudo systemctl disable 服务名
  
ps -eo pid,comm,cmd | grep -v '[k]ernel' | grep -v 'PID' | grep '^\s*[1-9]\d*\s*\S\+\s*'
列出所有的后台进程

}
haloblog_install(){
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker-ce
# 可选）如果你想让Docker在没有sudo权限的情况下运行，可以添加你的用户到docker组
# sudo usermod -aG docker $USER

# 安装Docker Compose
# uname -m
# x86_64
# uname -s
# Linux


sudo curl -L "https://github.com/docker/compose/releases/download/v2.28.0/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose



# 安装MySQL
sudo apt update


}



# 停止推流
stream_stop(){
	screen -S stream -X quit
	killall ffmpeg
	}

# 开始菜单设置
echo -e "${yellow}一键安装ffmpeg。兼容ubuntu&linux ${font}"
echo -e "${red} 此脚本是编译安装ffmpeg! ${font}"
echo -e "${green} 1.安装FFmpeg  ${font}"
echo -e "${green} 2.升级ffmpeg${font}"

echo -e "${green} 3.重装ffmpeg${font}"

echo -e "${green} 3.卸载 ${font}"
start_menu(){
    read -p "请输入数字(1-3),选择你要进行的操作:" num
    case"$num"in
        1)
        ffmpeg_install
        ;;
        2)
        stream_start
        ;;
        3)
        stream_stop
        ;;

        4)

        stream_stop

        ;;

        *)
        echo -e "${red} 请输入正确的数字 (1-3) ${font}"
        ;;
    esac
	}

# 运行开始菜单
start_menu
