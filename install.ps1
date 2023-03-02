# Install programs

## Browsers
winget.exe install Mozilla.Firefox
winget.exe install Google.Chrome

## Developer tools
winget.exe install Git.Git
winget.exe install Microsoft.PowerShell
winget.exe install Microsoft.PowerToys
winget.exe install Microsoft.VisualStudio.2022.BuildTools
winget.exe install Microsoft.VisualStudio.2022.Community
winget.exe install Microsoft.VisualStudioCode
winget.exe install Starship.Starship
winget.exe install Microsoft.WindowsTerminal
winget.exe install Neovim.Neovim
winget.exe install OpenJS.NodeJS
winget.exe install Python.Python.3.10
winget.exe install Microsoft.WindowsSDK
winget.exe install Microsoft.DotNet.DesktopRuntime.6
winget.exe install Kitware.CMake
winget.exe install LLVM.LLVM
winget.exe install Microsoft.DotNet.DesktopRuntime.5
winget.exe install vim.vim

## Social media
winget.exe install 9WZDNCRF0083 # Facebook Messenger
winget.exe install Discord.Discord
winget.exe install SlackTechnologies.Slack

# Gaming
winget.exe install Microsoft.VCRedist.2005.x64
winget.exe install Microsoft.VCRedist.2005.x86
winget.exe install Microsoft.VCRedist.2008.x64
winget.exe install Microsoft.VCRedist.2008.x86
winget.exe install Microsoft.VCRedist.2010.x64
winget.exe install Microsoft.VCRedist.2010.x86
winget.exe install Microsoft.VCRedist.2012.x64
winget.exe install Microsoft.VCRedist.2012.x86
winget.exe install Microsoft.VCRedist.2015+.x64
winget.exe install Microsoft.VCRedist.2015+.x86
winget.exe install Microsoft.VCRedist.2013.x64
winget.exe install Microsoft.VCRedist.2013.x86
winget.exe install Nvidia.GeForceExperience
winget.exe install Nvidia.CUDA
winget.exe install Nvidia.Broadcast
winget.exe install Nvidia.PhysX
winget.exe install Parsec.Parsec

## Miscellaneous
winget.exe install Google.ChromeRemoteDesktop
winget.exe install CodeSector.TeraCopy
winget.exe install AppWork.JDownloader
winget.exe install Dropbox.Dropbox
winget.exe install 7zip.7zip
winget.exe install 9PF4KZ2VN4W9 # TranslucentTB
winget.exe install 9MTFTXSJ9M7F # RoundedTB
winget.exe install Adobe.Acrobat.Reader.64-bit

# mpv
# Note, mpv comes from SVP4: https://www.svp-team.com/files/svp4-latest.php?offline
# Copy mpv files to $HOME\AppData\Roaming\mpv
$mpvFolder = ./mpv
Copy-Item -Path $mpvFolder -Destination $env:APPDATA -Recurse -Force