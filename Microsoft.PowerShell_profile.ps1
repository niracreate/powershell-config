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
                 fzf --height 50% --border `
                     --prompt ">" `
                     --preview '
                         $path = "{}"
                         if (Test-Path $path -PathType Container) {
                             lsd --tree --depth 3 "$path" 2>$null
                         } else {
                             bat --style=numbers --color=always "$path" 2>$null
                         }
                     ' `
                     --preview-window right:60%:wrap `
                     --bind '?:toggle-preview' `
                     --header 'Tip: type / at the end → folders only'

    if ($selection) {
        # If user typed / at the end in fzf query, treat as folder even if file exists
        $fullPath = Join-Path $PWD ($selection -replace '/$','')
        $fullPath = [System.IO.Path]::GetFullPath($fullPath)
        zed "$fullPath"
    }
}