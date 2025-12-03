#always open D drive on boot
Set-Location D:\

#zoxide setup
Invoke-Expression (& { (zoxide init powershell | Out-String) })

#starsip setup
Invoke-Expression (&starship init powershell)

# Ctrl+f → Smart file + folder finder (type / at the end → folders only)
Set-PSReadLineKeyHandler -Chord Ctrl+f -ScriptBlock {
    $selection = Get-ChildItem -Recurse -ErrorAction SilentlyContinue |
                 Resolve-Path -Relative |
                 fzf --height 40% --border --prompt "> "

    if ($selection) {
        $path = Join-Path $PWD ($selection -replace '/$','')   # strip possible trailing /
        $path = [System.IO.Path]::GetFullPath($path)           # normalize ..

        if (Test-Path $path) {
            zed "$path"
        }
    }
}