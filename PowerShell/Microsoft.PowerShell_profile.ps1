# For zoxide v0.8.0+
Invoke-Expression (& {
        $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
    (zoxide init --hook $hook powershell | Out-String)
    })

$ENV:STARSHIP_CONFIG = "$HOME\dotfiles\starship\starship-windows.toml"

# Starship.rs
Invoke-Expression (&starship init powershell)

# PSReadLine
# Must install first with
# Install-Module PSReadLine
Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History

# Aliases
function rm { Remove-Item -r -Force "${1}" }
function md { mkdir -Force "${1}" }
function l { Get-ChildItem }
Set-Alias vi vim.exe
Set-Alias vim nvim.exe
Set-Alias v nvim.exe
Set-Alias cat bat.exe
function gs { git status }
function gap { git add . && git commit && git push }
function wug { winget upgrade --all }
function wi($Package) { winget install $Package }
function wu($Package) { winget uninstall $Package }
function ws($Package) { winget search $Package }
