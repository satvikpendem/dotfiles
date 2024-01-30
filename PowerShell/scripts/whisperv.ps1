param(
    [Parameter()] [string] $File,
    [Parameter()] [ValidateSet('tiny', 'tiny.en', 'base', 'base.en', 'small', 'small.en', 'medium', 'medium.en', 'large', 'large-v1', 'large-v2', 'large-v3')] [string] $Model = "large-v3",
    [Parameter()] [ValidateSet('auto', 'cpu', 'cuda')] [string] $Processing_Unit = "cuda",
    # For generating subtitles only without packaging them into the video
    [switch] $SubtitlesOnly,
    [Parameter()] [ValidateSet('transcribe', 'translate')] [string] $Task = "transcribe",
    # For changing the language of Whisper. If it's not provided, Whisper will auto-detect
    [Parameter()] [ValidateSet('af', 'am', 'ar', 'as', 'az', 'ba', 'be', 'bg', 'bn', 'bo', 'br', 'bs', 'ca', 'cs', 'cy', 'da', 'de', 'el', 'en', 'es', 'et', 'eu', 'fa', 'fi', 'fo', 'fr', 'gl', 'gu', 'ha', 'haw', 'he', 'hi', 'hr', 'ht', 'hu', 'hy', 'id', 'is', 'it', 'ja', 'jw', 'ka', 'kk', 'km', 'kn', 'ko', 'la', 'lb', 'ln', 'lo', 'lt', 'lv', 'mg', 'mi', 'mk', 'ml', 'mn', 'mr', 'ms', 'mt', 'my', 'ne', 'nl', 'nn', 'no', 'oc', 'pa', 'pl', 'ps', 'pt', 'ro', 'ru', 'sa', 'sd', 'si', 'sk', 'sl', 'sn', 'so', 'sq', 'sr', 'su', 'sv', 'sw', 'ta', 'te', 'tg', 'th', 'tk', 'tl', 'tr', 'tt', 'uk', 'ur', 'uz', 'vi', 'yi', 'yo', 'zh', 'Afrikaans', 'Albanian', 'Amharic', 'Arabic', 'Armenian', 'Assamese', 'Azerbaijani', 'Bashkir', 'Basque', 'Belarusian', 'Bengali', 'Bosnian', 'Breton', 'Bulgarian', 'Burmese', 'Castilian', 'Catalan', 'Chinese', 'Croatian', 'Czech', 'Danish', 'Dutch', 'English', 'Estonian', 'Faroese', 'Finnish', 'Flemish', 'French', 'Galician', 'Georgian', 'German', 'Greek', 'Gujarati', 'Haitian', 'Haitian Creole', 'Hausa', 'Hawaiian', 'Hebrew', 'Hindi', 'Hungarian', 'Icelandic', 'Indonesian', 'Italian', 'Japanese', 'Javanese', 'Kannada', 'Kazakh', 'Khmer', 'Korean', 'Lao', 'Latin', 'Latvian', 'Letzeburgesch', 'Lingala', 'Lithuanian', 'Luxembourgish', 'Macedonian', 'Malagasy', 'Malay', 'Malayalam', 'Maltese', 'Maori', 'Marathi', 'Moldavian', 'Moldovan', 'Mongolian', 'Myanmar', 'Nepali', 'Norwegian', 'Nynorsk', 'Occitan', 'Panjabi', 'Pashto', 'Persian', 'Polish', 'Portuguese', 'Punjabi', 'Pushto', 'Romanian', 'Russian', 'Sanskrit', 'Serbian', 'Shona', 'Sindhi', 'Sinhala', 'Sinhalese', 'Slovak', 'Slovenian', 'Somali', 'Spanish', 'Sundanese', 'Swahili', 'Swedish', 'Tagalog', 'Tajik', 'Tamil', 'Tatar', 'Telugu', 'Thai', 'Tibetan', 'Turkish', 'Turkmen', 'Ukrainian', 'Urdu', 'Uzbek', 'Valencian', 'Vietnamese', 'Welsh', 'Yiddish', 'Yoruba')] [string] $Language = "English"
)

# Check if whisper-ctranslate2 is installed and exit if it's not, telling the user to install it
$whisper = Get-Command whisper-ctranslate2
if ($null -eq $whisper) {
    Write-Error "whisper-ctranslate2 is not installed. Please install it with `pip3 install git+https://github.com/jordimas/whisper-ctranslate2.git`\"
    return
}

if ($null -eq $File) {
    Write-Error "No file specified"
    return
}

if (-not (Test-Path $File)) {
    Write-Error "File does not exist: $File"
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

# Generate random file name for output
$chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
$basename = -join (1..20 | ForEach-Object { Get-Random -Maximum $chars.length | ForEach-Object { $chars[$_] } })
$video_file_name = "$basename$video_file_extension"
$audio_file_name = "$basename.wav"
$subtitled_audio = "$basename.$subtitle_format"
$subtitle_language = "English"

# Convert audio from each video to 16-bit 16kHz PCM WAV as Whisper requires
ffmpeg -i $File -ar 16000 -ac 1 -c:a pcm_s16le $audio_file_name

# Perform Whisper operation
whisper-ctranslate2 `
    --model "$Model" `
    --print_colors true `
    --device "$Processing_Unit" `
    --output_format "$subtitle_format" `
    --patience 3 `
    --word_timestamps true `
    --task "$task" `
    --language "$language" `
    "$audio_file_name"

if ($SubtitlesOnly) {
    Remove-Item $audio_file_name
    return
}

# Package the .srt file back into the video
ffmpeg -i $File -i $subtitled_audio -c copy -c:s $ffmpeg_subtitle_copy_format -metadata:s:s:0 title=$subtitle_language $video_file_name
# Rename the original video to a temporary name
$temp_file = "$File.bak"
Rename-Item -Force $File $temp_file
# Clean up files. Rename the video file to the original name. We use `-Force` to overwrite the file since the original video file is no longer needed.
Remove-Item -Force $audio_file_name*
Rename-Item -Force $video_file_name $File
Remove-Item -Force $temp_file
