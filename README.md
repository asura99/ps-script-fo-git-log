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
            "name": "project1",    	// project name(only show)
            "path": "project1 path in your computer",	// local path for your project
            "committer": "your name for git commit",	// show commit log for who(default: git config user.name)
            "enable": true	// whether show log
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
