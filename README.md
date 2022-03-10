# linqpad-folders-powershell-module

This module helps [LINQPad](https://www.linqpad.net/) users creating symbolic link for `LINQPad Plugins`, `LINQPad Queries`, and `LINQPad Snippets` folders to a folder from Dropbox, Google Drive, ...etc. So that you can share your scripts between multiple machines.

## Install

```ps1
Install-Module -Name linqpad-folders-powershell-module -Force
```

## Update

```ps1
Update-Module -Name linqpad-folders-powershell-module -Force
```

## Usage

1. Move default LINQPad folders to target and setup symbolic link to it.

    ```ps1
    Set-LINQPadFolder -TargetPath '~/Dropbox/Tools/LINQPad'
    ```

2. If your LINQPad's folders are not located at `~/Documents`, use  `-DefaultPath` to change default location.

    ```ps1
    Set-LINQPadFolder -DefaultPath 'C:\MyDocuments' -TargetPath '~/Dropbox/Tools/LINQPad'
    ```

## Remarks

- It will move files from default path to target path.
- It will create 3 symbolic links to your default path and target to your new location.
