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
# Import-Module PSReadLine
# Set-PSReadLineOption -PredictionSource History

# Aliases
function rm { Remove-Item -r -Force "${1}" }
function md { mkdir -Force "${1}" }
function l { Get-ChildItem }
Set-Alias vi vim.exe
Set-Alias vim nvim.exe
Set-Alias v nvim.exe
Set-Alias cat bat.exe
function gs { git status }
function gd { git diff }
function gap { git add . && git commit && git push }
function wug { winget upgrade --all --silent }
function wi($Package) { winget install $Package }
function wu($Package) { winget uninstall $Package }
function ws($Package) { winget search $Package }
function fbrb { flutter pub run build_runner build --delete-conflicting-outputs }
function fbrw { flutter pub run build_runner watch --delete-conflicting-outputs }
function cb($Crate) { cargo binstall --no-confirm $Crate }

function whisperv {
    param(
        [string] $File,
        [Parameter()] [ValidateSet('tiny', 'tiny.en', 'base', 'base.en', 'small', 'small.en', 'medium', 'medium.en', 'large', 'large-v1', 'large-v2')] [string] $Model = "base",
        [switch] $Cpu,
        # For generating subtitles only without packaging them into the video
        [switch] $SubtitlesOnly,
        [Parameter()] [ValidateSet('transcribe', 'translate')] [string] $Task = "transcribe",
        # For changing the language of Whisper. If it's not provided, Whisper will auto-detect
        [Parameter()] [ValidateSet('af', 'am', 'ar', 'as', 'az', 'ba', 'be', 'bg', 'bn', 'bo', 'br', 'bs', 'ca', 'cs', 'cy', 'da', 'de', 'el', 'en', 'es', 'et', 'eu', 'fa', 'fi', 'fo', 'fr', 'gl', 'gu', 'ha', 'haw', 'he', 'hi', 'hr', 'ht', 'hu', 'hy', 'id', 'is', 'it', 'ja', 'jw', 'ka', 'kk', 'km', 'kn', 'ko', 'la', 'lb', 'ln', 'lo', 'lt', 'lv', 'mg', 'mi', 'mk', 'ml', 'mn', 'mr', 'ms', 'mt', 'my', 'ne', 'nl', 'nn', 'no', 'oc', 'pa', 'pl', 'ps', 'pt', 'ro', 'ru', 'sa', 'sd', 'si', 'sk', 'sl', 'sn', 'so', 'sq', 'sr', 'su', 'sv', 'sw', 'ta', 'te', 'tg', 'th', 'tk', 'tl', 'tr', 'tt', 'uk', 'ur', 'uz', 'vi', 'yi', 'yo', 'zh', 'Afrikaans', 'Albanian', 'Amharic', 'Arabic', 'Armenian', 'Assamese', 'Azerbaijani', 'Bashkir', 'Basque', 'Belarusian', 'Bengali', 'Bosnian', 'Breton', 'Bulgarian', 'Burmese', 'Castilian', 'Catalan', 'Chinese', 'Croatian', 'Czech', 'Danish', 'Dutch', 'English', 'Estonian', 'Faroese', 'Finnish', 'Flemish', 'French', 'Galician', 'Georgian', 'German', 'Greek', 'Gujarati', 'Haitian', 'Haitian Creole', 'Hausa', 'Hawaiian', 'Hebrew', 'Hindi', 'Hungarian', 'Icelandic', 'Indonesian', 'Italian', 'Japanese', 'Javanese', 'Kannada', 'Kazakh', 'Khmer', 'Korean', 'Lao', 'Latin', 'Latvian', 'Letzeburgesch', 'Lingala', 'Lithuanian', 'Luxembourgish', 'Macedonian', 'Malagasy', 'Malay', 'Malayalam', 'Maltese', 'Maori', 'Marathi', 'Moldavian', 'Moldovan', 'Mongolian', 'Myanmar', 'Nepali', 'Norwegian', 'Nynorsk', 'Occitan', 'Panjabi', 'Pashto', 'Persian', 'Polish', 'Portuguese', 'Punjabi', 'Pushto', 'Romanian', 'Russian', 'Sanskrit', 'Serbian', 'Shona', 'Sindhi', 'Sinhala', 'Sinhalese', 'Slovak', 'Slovenian', 'Somali', 'Spanish', 'Sundanese', 'Swahili', 'Swedish', 'Tagalog', 'Tajik', 'Tamil', 'Tatar', 'Telugu', 'Thai', 'Tibetan', 'Turkish', 'Turkmen', 'Ukrainian', 'Urdu', 'Uzbek', 'Valencian', 'Vietnamese', 'Welsh', 'Yiddish', 'Yoruba')] [string] $Language)

    if ($null -eq $File) {
        Write-Error "No file specified"
        return
    }

    if (-not (Test-Path $File)) {
        Write-Error "File does not exist: $File"
        return
    }

    if ($Cpu -and ($Model -eq "large-v1" -or $Model -eq "large-v2")) {
        Write-Error "large-v1 and large-v2 models are not available on CPU"
        return
    }

    $video_file_extension = [System.IO.Path]::GetExtension($File)
    if ($video_file_extension -eq ".mp4") {
        $subtitle_format = "srt"
        $ffmpeg_subtitle_copy_format = "mov_text"
    }
    elseif ($video_file_extension -eq ".mkv") {
        $subtitle_format = "vtt"
        $ffmpeg_subtitle_copy_format = "srt"
    }
    else {
        Write-Error "Unsupported video format: $video_file_extension"
        return
    }

    $video_file_name = "output$video_file_extension"

    $audio_file_name = "output.wav"
    $subtitled_audio = "$audio_file_name.$subtitle_format"
    $subtitle_language = "English"

    if ($Cpu) {
        $whisper_path = "C:\Program Files\whisper-bin-x64"
        $whisper_exe = "$whisper_path\main.exe"
        $whisper_models = "$whisper_path\models"
        $default_model = "$whisper_models\ggml-$Model.bin"
    }
    else {
        # From the official OpenAI Whisper repo:
        # pip install git+https://github.com/openai/whisper.git
        $whisper_exe = "whisper"
        $default_model = $Model

        # From the unofficial C++ GPU implementation:
        # https://github.com/Const-me/Whisper
        #
        # $whisper_path = "C:\Program Files\whisper-bin-x64"
        # $whisper_exe = "$whisper_path\cli\main.exe"
        # $whisper_models = "$whisper_path\models"
        # $default_model = "$whisper_models\ggml-$Model.bin"
    }

    # Convert audio from each video to 16-bit 16kHz PCM WAV as Whisper.cpp requires
    ffmpeg -i $File -ar 16000 -ac 1 -c:a pcm_s16le $audio_file_name

    # Use Whisper.cpp to transcribe each audio file and output a .srt file  
    if ($Cpu) {
        & "$whisper_exe" -m $default_model --threads (Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors --output-$subtitle_format --print-colors $audio_file_name
    }
    else {
        # GPU
        if ($Language) {
            $languageParameter = "--language $Language"
        }
        & "$whisper_exe" --model large-v2 --device cuda $audio_file_name --task $Task $languageParameter
        
        # Alternative GPU implementation:
        # https://github.com/Const-me/Whisper
        #
        # if ($Task -eq "translate") {
        #     $Translate = "--translate"
        # }
        # & "$whisper_exe" --model $default_model $Translate --language $Language --threads (Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors --processors (Get-CimInstance Win32_ComputerSystem).NumberOfProcessors --output-$subtitle_format $audio_file_name
    }

    if ($SubtitlesOnly) {
        Remove-Item $audio_file_name
        return
    }

    # Package the .srt file back into the video
    ffmpeg -i $File -i $subtitled_audio -c copy -c:s $ffmpeg_subtitle_copy_format -metadata:s:s:0 title=$subtitle_language $video_file_name
    # Rename the video file to the original name. We use `-Force` to overwrite the file since the original video file is no longer needed.
    Move-Item -Force $video_file_name $File
    # Clean up files
    Remove-Item $audio_file_name*
}

# Modified from https://github.com/TheFrenchGhosty/TheFrenchGhostys-Ultimate-YouTube-DL-Scripts-Collection
function yt {
    param([string]$Url, [switch]$Subtitles),
    [switch] $Audio, 

    $output = "%(title)s.%(ext)s"
    if ($Url -match "playlist") {
        $output = "%(playlist)s/%(playlist_index)04d - %(title)s.%(ext)s" 
    }

    if ($Audio) {
        $format = "bestaudio[acodec^=opus]/bestaudio/best"
        $output_format = "mp3"
    }
    else {
        $format = "(bestvideo[vcodec^=av01][height>=4320][fps>30]/bestvideo[vcodec^=vp9.2][height>=4320][fps>30]/bestvideo[vcodec^=vp9][height>=4320][fps>30]/bestvideo[vcodec^=avc1][height>=4320][fps>30]/bestvideo[height>=4320][fps>30]/bestvideo[vcodec^=av01][height>=4320]/bestvideo[vcodec^=vp9.2][height>=4320]/bestvideo[vcodec^=vp9][height>=4320]/bestvideo[vcodec^=avc1][height>=4320]/bestvideo[height>=4320]/bestvideo[vcodec^=av01][height>=2880][fps>30]/bestvideo[vcodec^=vp9.2][height>=2880][fps>30]/bestvideo[vcodec^=vp9][height>=2880][fps>30]/bestvideo[vcodec^=avc1][height>=2880][fps>30]/bestvideo[height>=2880][fps>30]/bestvideo[vcodec^=av01][height>=2880]/bestvideo[vcodec^=vp9.2][height>=2880]/bestvideo[vcodec^=vp9][height>=2880]/bestvideo[vcodec^=avc1][height>=2880]/bestvideo[height>=2880]/bestvideo[vcodec^=av01][height>=2160][fps>30]/bestvideo[vcodec^=vp9.2][height>=2160][fps>30]/bestvideo[vcodec^=vp9][height>=2160][fps>30]/bestvideo[vcodec^=avc1][height>=2160][fps>30]/bestvideo[height>=2160][fps>30]/bestvideo[vcodec^=av01][height>=2160]/bestvideo[vcodec^=vp9.2][height>=2160]/bestvideo[vcodec^=vp9][height>=2160]/bestvideo[vcodec^=avc1][height>=2160]/bestvideo[height>=2160]/bestvideo[vcodec^=av01][height>=1440][fps>30]/bestvideo[vcodec^=vp9.2][height>=1440][fps>30]/bestvideo[vcodec^=vp9][height>=1440][fps>30]/bestvideo[vcodec^=avc1][height>=1440][fps>30]/bestvideo[height>=1440][fps>30]/bestvideo[vcodec^=av01][height>=1440]/bestvideo[vcodec^=vp9.2][height>=1440]/bestvideo[vcodec^=vp9][height>=1440]/bestvideo[vcodec^=avc1][height>=1440]/bestvideo[height>=1440]/bestvideo[vcodec^=av01][height>=1080][fps>30]/bestvideo[vcodec^=vp9.2][height>=1080][fps>30]/bestvideo[vcodec^=vp9][height>=1080][fps>30]/bestvideo[vcodec^=avc1][height>=1080][fps>30]/bestvideo[height>=1080][fps>30]/bestvideo[vcodec^=av01][height>=1080]/bestvideo[vcodec^=vp9.2][height>=1080]/bestvideo[vcodec^=vp9][height>=1080]/bestvideo[vcodec^=avc1][height>=1080]/bestvideo[height>=1080]/bestvideo[vcodec^=av01][height>=720][fps>30]/bestvideo[vcodec^=vp9.2][height>=720][fps>30]/bestvideo[vcodec^=vp9][height>=720][fps>30]/bestvideo[vcodec^=avc1][height>=720][fps>30]/bestvideo[height>=720][fps>30]/bestvideo[vcodec^=av01][height>=720]/bestvideo[vcodec^=vp9.2][height>=720]/bestvideo[vcodec^=vp9][height>=720]/bestvideo[vcodec^=avc1][height>=720]/bestvideo[height>=720]/bestvideo[vcodec^=av01][height>=480][fps>30]/bestvideo[vcodec^=vp9.2][height>=480][fps>30]/bestvideo[vcodec^=vp9][height>=480][fps>30]/bestvideo[vcodec^=avc1][height>=480][fps>30]/bestvideo[height>=480][fps>30]/bestvideo[vcodec^=av01][height>=480]/bestvideo[vcodec^=vp9.2][height>=480]/bestvideo[vcodec^=vp9][height>=480]/bestvideo[vcodec^=avc1][height>=480]/bestvideo[height>=480]/bestvideo[vcodec^=av01][height>=360][fps>30]/bestvideo[vcodec^=vp9.2][height>=360][fps>30]/bestvideo[vcodec^=vp9][height>=360][fps>30]/bestvideo[vcodec^=avc1][height>=360][fps>30]/bestvideo[height>=360][fps>30]/bestvideo[vcodec^=av01][height>=360]/bestvideo[vcodec^=vp9.2][height>=360]/bestvideo[vcodec^=vp9][height>=360]/bestvideo[vcodec^=avc1][height>=360]/bestvideo[height>=360]/bestvideo[vcodec^=avc1][height>=240][fps>30]/bestvideo[vcodec^=av01][height>=240][fps>30]/bestvideo[vcodec^=vp9.2][height>=240][fps>30]/bestvideo[vcodec^=vp9][height>=240][fps>30]/bestvideo[height>=240][fps>30]/bestvideo[vcodec^=avc1][height>=240]/bestvideo[vcodec^=av01][height>=240]/bestvideo[vcodec^=vp9.2][height>=240]/bestvideo[vcodec^=vp9][height>=240]/bestvideo[height>=240]/bestvideo[vcodec^=avc1][height>=144][fps>30]/bestvideo[vcodec^=av01][height>=144][fps>30]/bestvideo[vcodec^=vp9.2][height>=144][fps>30]/bestvideo[vcodec^=vp9][height>=144][fps>30]/bestvideo[height>=144][fps>30]/bestvideo[vcodec^=avc1][height>=144]/bestvideo[vcodec^=av01][height>=144]/bestvideo[vcodec^=vp9.2][height>=144]/bestvideo[vcodec^=vp9][height>=144]/bestvideo[height>=144]/bestvideo)+(bestaudio[acodec^=opus]/bestaudio)/best" 
        $output_format = "mp4"
    }

    yt-dlp --sponsorblock-remove all --progress --console-title --format $format --no-continue --embed-metadata --parse-metadata "%(title)s:%(meta_title)s" --parse-metadata "%(uploader)s:%(meta_artist)s" --embed-thumbnail --embed-subs --sub-langs "all,-live_chat" --concurrent-fragments 5 --output $output --merge-output-format $output_format "$Url"
    
    # Use Whisper.cpp to transcribe audio from each video, save to a .srt file, and package the subtitle back into the video
    if ($subtitles) {
        foreach ($file in Get-ChildItem *$output_format) {
            whisper($file)
        }
    }
}

function yts($Url, $Audio) {
    yt $Url $Audio -Subtitles
}
