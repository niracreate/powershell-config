#always open D drive on boot
Set-Location D:\

#zoxide setup
Invoke-Expression (& { (zoxide init powershell | Out-String) })

#starsip setup
Invoke-Expression (&starship init powershell)

# Ctrl+f → fuzzy-find and open the selected FOLDER (not file) in Zed
Set-PSReadLineKeyHandler -Chord Ctrl+f -ScriptBlock {
    $selection = Get-ChildItem -Directory -Recurse -ErrorAction SilentlyContinue |
                 Resolve-Path -Relative |
                 fzf --height 40% --border --prompt="Folder > "

    if ($selection) {
        $fullPath = Join-Path $PWD $selection
        $fullPath = [System.IO.Path]::GetFullPath($fullPath)
        zed "$fullPath"
    }
}