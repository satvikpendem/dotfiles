# For zoxide v0.8.0+
Invoke-Expression (& {
        $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
    (zoxide init --hook $hook powershell | Out-String)
    })

$ENV:STARSHIP_CONFIG = "$HOME\dotfiles\starship\starship-windows.toml"

# Starship.rs
Invoke-Expression (&starship init powershell)

# fnm (fast Node manager) https://github.com/Schniz/fnm
fnm env --use-on-cd | Out-String | Invoke-Expression

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
function wug { winget upgrade --all --silent }
function wi($Package) { winget install $Package }
function wu($Package) { winget uninstall $Package }
function ws($Package) { winget search $Package }
function brb { flutter pub run build_runner build --delete-conflicting-outputs }
function brw { flutter pub run build_runner watch --delete-conflicting-outputs }
function yt { yt-dlp --embed-metadata --embed-subs --embed-thumbnail -o "%(title)s.%(ext)s" -f 'bestvideo[height<=8192]+bestaudio/best[height<=8192]' "${1}" }
function ytp { yt-dlp --embed-metadata --embed-subs --embed-thumbnail -o "%(playlist_index)04d - %(title)s.%(ext)s" -f 'bestvideo[height<=8192]+bestaudio/best[height<=8192]' "${1}"}
