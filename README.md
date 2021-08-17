# ps-script-fo-git-log
## Prepare

- **Make sure your PowerShell version is larger than 7**

Use the command to check your version:

```sh
> $PSVersionTable.PSVersion
```

If your **Major >= 7**. It's great.

- Make sure `gitlog.json` in your `$HOME`

```json
// $HOME/gitlog.json
{
    "projects": [
        {
            // project name(only show)
            "name": "project1",
            // local path for your project
            "path": "project1 path in your computer",
            // show commit log for who(default: git config user.name)
            "committer": "your name for git commit",
            // whether show log
            "enable": true
        },
        {
            "name": "project2",
            "path": "project2 path in your computer",
            "enable": false
        }
    ]
}
```



## Usage

```sh
Usages: gitlog.ps1 <arg>
  arg: 
    d   today
    dl  yesterday
    w   this week
    wl  last week
    m   this month
    ml  last month
```



## End

You can modify this script to customize your content.
