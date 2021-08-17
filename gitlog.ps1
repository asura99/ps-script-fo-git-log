# 获取commit记录
param
(
    [string]$arg
)
# 读取配置文件
$confPath = "$HOME/gitlog.json"
if ((Test-Path $confPath) -eq $False) {
    Write-Host "配置文件不存在，请在 $HOME 路径下创建gitlog.json文件"
    Exit
}
$CONF = (Get-Content $confPath) | ConvertFrom-Json
# 获取当前时间
$currentTime = Get-Date

$time = [PSCustomObject][Ordered]@{startTime=""; endTime="";}

$weeknow = $currentTime.DayOfWeek
if ($weeknow -eq 0) {
    $weeknow = 0
}

$daydiff = (-1) * $weeknow + 1;
$dayadd = 7 - $weeknow;

# 本周第一天
$firstOfWeek = $currentTime.AddDays($daydiff)
# 本周最后一天
$endOfWeek = $currentTime.AddDays($dayadd)
# 本月第一天
$firstOfMonth = $currentTime.AddDays(-($currentTime.Day) + 1)
# 本月最后一天
$endOfMonth = $currentTime.AddMonths(1).AddDays(-($currentTime.Day))

switch -regex ($arg)
{
    "^d$"
    {
        $time.startTime = $currentTime.toString("yyyy-MM-dd");
        $time.endTime = $currentTime.AddDays(1).toString("yyyy-MM-dd");
        break
    }
    "^dl$"
    {
        $time.startTime = $currentTime.AddDays(-1).toString("yyyy-MM-dd");
        $time.endTime = $currentTime.toString("yyyy-MM-dd");
        break
    }
    "^w$"
    {
        $time.startTime = $firstOfWeek.toString("yyyy-MM-dd");
        $time.endTime = $endOfWeek.toString("yyyy-MM-dd");
        break
    }
    "^wl$"
    {
        $time.startTime = $firstOfWeek.AddDays(-7).toString("yyyy-MM-dd");
        $time.endTime = $endOfWeek.AddDays(-7).toString("yyyy-MM-dd");
        break
    }
    "^m$"
    {
        $time.startTime = $firstOfMonth.toString("yyyy-MM-dd");
        $time.endTime = $endOfMonth.toString("yyyy-MM-dd");
        break
    }
    "^ml$"
    {
        $time.startTime = $firstOfMonth.AddMonths(-1).toString("yyyy-MM-dd");
        $time.endTime = $endOfMonth.AddMonths(-1).toString("yyyy-MM-dd");
        break
    }
    "^h(elp)?$"
    {
        Write-Host "Usages: gitlog.ps1 <arg>"
        Write-Host "  arg: "
        Write-Host "    d   today"
        Write-Host "    dl  yesterday"
        Write-Host "    w   this week"
        Write-Host "    wl  last week"
        Write-Host "    m   this month"
        Write-Host "    ml  last month"
        Exit
    }
    default
    {
        Write-Host "参数错误或缺失，请使用 gitlog.ps1 h(elp) 查看帮助！"
        Exit
    }
    
}

# 当前执行的路径 - 方便一会返回
$currentPath = Get-Location

# 获取项目列表
$projects = $CONF.projects

# 输出Log的方法
function printLog
{
    param($project, $t)
    Write-Host '==== '$project.name $t.startTime '~' $t.endTime ' ===='
    # 进入项目路径
    Set-Location $project.path
    # 获取committer
    if ($project.committer -eq $null) {
        $committer = git config user.name
    } else {
        $committer = $project.committer
    }

    # 不能直接调用后者，--since=@{startTime=2021-08-16; endTime=2021-08-17}.startTime
    $ts = $t.startTime
    $te = $t.endTime

    # 输出log
    git log `
        --author=$committer `
        --no-merges `
        --pretty=format:"%C(yellow)%cd%Creset %s" `
        --date=relative `
        --since="$ts" `
        --until="$te" 
	
}

# 遍历项目
forEach($project in $projects) 
{
    if ($project.enable -eq $true) {
        printLog $project $time
    }
}

# 返回调用位置
Set-Location $currentPath

