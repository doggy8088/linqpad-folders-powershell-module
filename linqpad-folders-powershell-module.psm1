function Set-LINQPadFolder {

    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter()]
        [string]
        $DefaultPath = '~/Documents',

        [Parameter()]
        [string]
        $TargetPath = '~/Dropbox/Tools/LINQPad'
    )

    # 如果發生錯誤，程式就要停下來
    $ErrorActionPreference = 'Stop'

    $DefaultPath = (Resolve-Path -Path $DefaultPath).Path
    $TargetPath = (Resolve-Path -Path $TargetPath).Path

    $linkFolders = "LINQPad Queries","LINQPad Plugins","LINQPad Snippets"

    $linkFolders | ForEach-Object {

        # 無論有沒有來源資料夾，都要建立目的資料夾
        # https://stackoverflow.com/a/46586504/910074
        [void](New-Item -Path "$TargetPath\$_" -ItemType Directory -Force)

        # 將原始檔案搬過去
        Write-Output "Moving $DefaultPath\$_ to $TargetPath\$_ ..."

        # 判斷有沒有來源資料夾，如果有就要把檔案備份過去
        if (Test-Path -Path "$DefaultPath\$_") {
            try {

                if ((Get-Item -Path "$DefaultPath\$_").LinkType -eq 'SymbolicLink') {
                    if ((Get-Item -Path "$DefaultPath\$_").Target -eq "$TargetPath\$_") {
                        # 如果原本的 SymbolicLink 指向同一個 Target 就不複製檔案
                    }
                    else {
                        Copy-Item -Path "$DefaultPath\$_\*" -Destination "$TargetPath\$_" -Recurse -ErrorAction Stop -Force
                    }

                    # 不用刪除刪除 SymbolicLink 的來源資料夾，最後直接覆蓋即可
                    # (Get-Item -Path "C:\Users\User\Documents\LINQPad Queries").Delete()
                }
                else {
                    # 搬遷檔案過去
                    Copy-Item -Path "$DefaultPath\$_\*" -Destination "$TargetPath\$_" -Recurse -ErrorAction Stop -Force

                    # 刪除來源資料夾
                    Remove-Item -Path "$DefaultPath\$_" -Recurse -Force
                }

                Write-Output "Done"
            }
            catch {
                throw "Unable moving files: $($error[0])"
            }
        }
        else {
            Write-Output "Done"
        }

        # 建立軟連結
        Write-Output "Creating symbolic link: $DefaultPath\$_"
        [void](New-Item -ItemType SymbolicLink -Path "$DefaultPath\$_" -Target "$TargetPath\$_" -Force)

    }
}
