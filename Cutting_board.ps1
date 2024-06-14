Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;

    public static class Clipboard {
        [DllImport("User32.dll")]
        public static extern int GetClipboardSequenceNumber();
    }
"@

do {
    $input = Read-Host "中文显示按 1 后回车`nEnglish Display Press 2 Enter,`nPress Enter 3 to enter author YouTube homepage`n,按 3 后回车进入作者的youtube主页"

    switch ($input) {
        1 { 
            Write-Output "脚本由youtube|qinqqz_z 制作，关注晴晴子获取更多精彩,`n点开软件后,输入txt文本保存的位置，软件自动检测剪切板的内容，`n监听到50条后或剪切板内容出现ok后，则把剪切版的内容保存到txt文件"
            break
        }
        2 { 
            Write-Output "The script is created by YouTube | qinqqz_ z  |Production: Follow Qingqingzi for more exciting content.`n After opening the software, enter the location where the txt text will be saved. `nThe software will automatically detect the content of the clipboard. If 50 pieces are detected or if the clipboard content appears OK, the clipboard content will be saved to a txt file" 
            break
        }
        3 {
            Start-Process "https://www.youtube.com/channel/UCFOhUcs87CWbPEM0UyQzSKA"
            break
        }
        default { Write-Output "你输入了无效的数字。You entered an invalid number" }
    }
} while ($input -ne 1 -and $input -ne 2)

Write-Host ""

if ($input -eq 1) {
   while ($true) {
    $saveDir = Read-Host -Prompt "请输入保存剪贴板内容的文件的目录"
    if (Test-Path $saveDir) {
        break
    } else {
        Write-Host "路径无效，请重新输入"
    }
}
} 
# 此处是路径有效时要执行的代码
elseif ($input -eq 2) {
while ($true) {
    $saveDir = Read-Host -Prompt "Please enter the directory of the file where you want to save the clipboard content"
    if (Test-Path $saveDir) {
        break
    } else {
        Write-Host "The path is invalid. Please re-enter it"
    }
}
} 

$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$savePath = Join-Path $saveDir ("$timestamp.txt")

$prevClipboardText = ""
$prevSeqNum = [Clipboard]::GetClipboardSequenceNumber()
$counter = 0

while ($true) {
    Start-Sleep -Seconds 1

    $currentSeqNum = [Clipboard]::GetClipboardSequenceNumber()

    if ($currentSeqNum -ne $prevSeqNum) {
        $currentClipboardText = Get-Clipboard -TextFormatType Text -ErrorAction SilentlyContinue
        $currentTime = Get-Date -Format "HH:mm:ss"  # 获取当前时间

        if ($currentClipboardText -ne $prevClipboardText) {
            $outputText = $currentTime + " ------------------------------------------ " +"`n" + $currentClipboardText  # 时间和剪贴板内容用特定字符串隔开
            Write-Host $outputText  # 输出当前剪贴板的内容和时间

            $outputText | Out-File -Append -FilePath $savePath
            $prevClipboardText = $currentClipboardText
            $counter++
        }

        if ($currentClipboardText -eq "ok" -or $counter -ge 50) {  # 如果剪贴板的内容是"ok"或者累计记录50次后，直接退出循环
            break
        }

        $prevSeqNum = $currentSeqNum
    }
}
