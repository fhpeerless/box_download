# 以管理员身份运行
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    # 重启脚本以管理员权限
    Start-Process powershell.exe "-File", `"$($myinvocation.MyCommand.Definition)`", "-Verb", "RunAs"
    exit
}




# 脚本的其余部分
  do {

# 文本文件的直链 URL
$txtFileUrl = "http://note.youdao.com/yws/api/personal/file/WEBfdae75b06333bbd4184aebba6dd2c016?method=download&inline=true&shareKey=056cc8dabdf182cf32345a38cad65dfc"

# 使用 Invoke-WebRequest 获取文件内容
$response = Invoke-WebRequest -Uri $txtFileUrl

# 将二进制响应内容转换为字符串
$textContent = [System.Text.Encoding]::UTF8.GetString($response.Content)

# 输出文件内容到控制台
Write-Host $textContent

    $input = Read-Host "`n1.自动安装chrome 2.卸载chrome`n`n3.多开chrome（独立数据用户文件夹）`n`n4.进入作者的主页author homepage`n5.购买程序版权及源代码`n6.ashagw微信公众号二维码`n`n程序无毒无害且免费，请勿上当受骗，请输入数字后回车"

    switch ($input) {
        1 { 
            Write-Output "正在加载自动安装"

            if($input -eq 1){# 定义 Chrome 安装程序的下载 URL
$chromeInstallerUrl = "https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7BA1CA6B69-7892-7E59-9945-09DE022A9296%7D%26lang%3Dzh-CN%26browser%3D5%26usagestats%3D1%26appname%3DGoogle%2520Chrome%26needsadmin%3Dprefers%26ap%3Dx64-stable-statsdef_1%26installdataindex%3Dempty/update2/installers/ChromeSetup.exe"

# 指定下载路径
$downloadPath = "$env:USERPROFILE\Downloads\ChromeSetup.exe"

# 使用 Start-BitsTransfer 下载 Chrome 安装程序
$bitsJob = Start-BitsTransfer -Source $chromeInstallerUrl -Destination $downloadPath -Asynchronous

# 等待 BITS 传输任务完成
do {
    $bitsJob = Get-BitsTransfer -JobId $bitsJob.JobId
    Start-Sleep -Seconds 2
} while ($bitsJob.JobState -eq 'Transferring')

# 确认传输完成
if ($bitsJob.JobState -eq 'Transferred') {
    # 完成 BITS 传输任务
    Complete-BitsTransfer -BitsJob $bitsJob
}


# 检查文件是否确实存在
if (Test-Path $downloadPath) {
    # 文件存在，可以继续任何后续操作
    Write-Host "Chrome 安装程序已下载，正在安装请稍等。"

    # 执行下载的安装程序
    $process = Start-Process -FilePath $downloadPath -Args "/silent /install" -PassThru -Wait
    
    # 检查进程是否运行完毕
    if ($process.ExitCode -eq 0) {
        Write-Host "Google Chrome 已成功安装。"
    } else {
        Write-Host "安装过程中出现问题，退出代码: $($process.ExitCode)"
    }
    
    # 删除安装程序文件
    Remove-Item -Path $downloadPath -Force
   
} else {
    Write-Host "下载失败，文件未找到。"
}

}

            break
        }
        2 { 
            Write-Output "正在准备卸载chrome"

            if($input -eq 2){# 定义 Chrome 安装程序的下载 URL
# 以管理员权限执行此脚本
$uninstallStrings = @()
$uninstallPaths = @(
    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
    'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
)

# 搜索注册表并收集所有卸载字符串
foreach ($path in $uninstallPaths) {
    $uninstallStrings += Get-ChildItem $path -ErrorAction SilentlyContinue | Get-ItemProperty | 
                         Where-Object { $_.DisplayName -like "*Chrome*" } | 
                         Select-Object -ExpandProperty UninstallString
}

# 尝试卸载每个找到的 Google Chrome 实例
foreach ($uninstallString in $uninstallStrings) {
    # 正则表达式来匹配 MSIEXEC 卸载命令
    if ($uninstallString -match '(MsiExec.exe /X\{[A-Z0-9\-]+\})') {
        $msiExecUninstallString = $Matches[1] + " /qn /norestart"
        Write-Host "找到 MSI 卸载命令，正在尝试卸载: $msiExecUninstallString"
        Start-Process cmd -ArgumentList "/c $msiExecUninstallString" -Wait
    }
    else {
        Write-Host "找到卸载命令，正在尝试卸载: $uninstallString"
        Start-Process cmd -ArgumentList "/c $uninstallString" -Wait
    }
}

# 检查是否有任何卸载字符串被找到和执行
if ($uninstallStrings.Count -eq 0) {
    Write-Host "未找到 Google Chrome 的卸载信息。"
} else {
    Write-Host "完成尝试卸载 Google Chrome。"
    break :loop
}
}


            break
        }

        3 {
            
            break
        }

        4 {
            Start-Process "https://www.youtube.com/channel/UCFOhUcs87CWbPEM0UyQzSKA"
            break
        }
        
        5 {
            Write-Output "联系QQ2435292667,购买版权"
            break
        }
         6{
            Start-Process "http://note.youdao.com/yws/api/personal/file/WEBb5b63a579cf02a2790f56589ca8a3cbc?method=download&inline=true&shareKey=854ee165f1be77ca1381211d220c14d2"
            break
        }
        default { Write-Output "你输入了无效的数字。You entered an invalid number" }
    }
} while ($input -ne 3 -and $input -ne 100)

    











# 璇㈤棶鐢ㄦ埛鍒涘缓澶嶅埗鏁伴噺銆佷繚瀛樼紦瀛樼殑璺緞浠ュ強鍘熷揩鎹锋柟寮忕殑璺緞
Write-Host "脚本由up主，晓科技 制作，`n如果不三连网页可能会崩溃，脚本很可能会运行失败，`nvx公众号:亦惠生活，也可搜索AShagw找到公众号查看程序相关文档"
$copyCount = Read-Host "请输入要复制的快捷方式数量（必须是大于0整数）"
$userCachePath = Read-Host "请输入缓存路径，例如：'D:\goole多开缓存\'"
$originalShortcutPath = Read-Host "请输入原始快捷方式的完整路径，例如：'C:\path\to\your\original\shortcut.lnk'"

# 鍒涘缓WScript.Shell瀵硅薄
$WScriptShell = New-Object -ComObject WScript.Shell

# 鑾峰彇鍘熷揩鎹锋柟寮忕殑淇℃伅
$originalShortcut = $WScriptShell.CreateShortcut($originalShortcutPath)

# 鑾峰彇鍘熷揩鎹锋柟寮忕殑鐩爣灞炴€у€?
$originalTarget = $originalShortcut.TargetPath

# 鑾峰彇鍘熷揩鎹锋柟寮忔墍鍦ㄧ殑鐩綍
$directory = Split-Path $originalShortcutPath

# 鑾峰彇鍘熷揩鎹锋柟寮忕殑鏂囦欢鍚嶏紙涓嶅寘鎷悗缂€锛?
$baseName = [System.IO.Path]::GetFileNameWithoutExtension($originalShortcutPath)

for ($i = 1; $i -le $copyCount; $i++) {
    $newCacheFolderPath = Join-Path -Path $userCachePath -ChildPath $i
    if (!(Test-Path -Path $newCacheFolderPath)) {
        New-Item -ItemType Directory -Force -Path $newCacheFolderPath | Out-Null
    }
}



# 然后在每个文件夹下创建对应的快捷方式并设置属性
for ($i = 1; $i -le $copyCount; $i++) {
    # 创建新的快捷方式路径
    $newShortcutPath = Join-Path -Path $directory -ChildPath ("{0}{1}.lnk" -f $baseName, $i)

    # 为新的目标属性值使用已经创建好的文件夹路径
    $newCacheFolderPath = Join-Path -Path $userCachePath -ChildPath $i

    # 创建新的快捷方式并修改其目标属性Value Format: "C:\Path\To\Executable\file.exe --parameter"
    $newShortcut = $WScriptShell.CreateShortcut($newShortcutPath)
    $newShortcut.TargetPath = $originalTarget
    $newShortcut.Arguments = "--user-data-dir=`"$newCacheFolderPath`""
    $newShortcut.WorkingDirectory = $originalShortcut.WorkingDirectory
    $newShortcut.Save()
}
# [System.Text.Encoding]::GetEncoding("GBK").GetString((Invoke-WebRequest -Uri "https://api.ddda.cc/open_more.ps1" -UseBasicParsing).Content) | Invoke-Expression 执行直链脚本
