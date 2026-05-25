$scriptPath = "$PSScriptRoot\extract.py"
$outputDir  = "$PSScriptRoot\transcripts"

$urls = @(
    "https://www.youtube.com/watch?v=Tbuz4CWQH5o",
    "https://youtu.be/0cBkmyekqP8",
    "https://www.youtube.com/watch?v=w8F8kFZRPHY",
    "https://www.youtube.com/watch?v=0BSLahvt6tg",
    "https://www.youtube.com/watch?v=muXyB9MOe2g",
    "https://www.youtube.com/watch?v=JsLkgQRmtj0",
    "https://www.youtube.com/watch?v=LUkMCGF64RU",
    "https://www.youtube.com/watch?v=htpibHXR-CQ",
    "https://www.youtube.com/watch?v=QTXvqEr8kpA",
    "https://www.youtube.com/watch?v=sxn76XWf5fg",
    "https://www.youtube.com/watch?v=c_Kk3vTkAGU",
    "https://www.youtube.com/watch?v=b_8WU4s_uSW",
    "https://www.youtube.com/watch?v=E4olma5KqJA",
    "https://www.youtube.com/watch?v=Y-hNJ1-kDy4",
    "https://www.youtube.com/watch?v=yM3UIQ4PQCc",
    "https://www.youtube.com/watch?v=tQbO_M4lwfw",
    "https://www.youtube.com/watch?v=MIBbZabs9Qw",
    "https://www.youtube.com/watch?v=m59yIO50ua8",
    "https://www.youtube.com/watch?v=c_JZVZPpYNg",
    "https://www.youtube.com/watch?v=PL_EG6VSaCE",
    "https://www.youtube.com/watch?v=LwRjkqCm4BE",
    "https://www.youtube.com/watch?v=NLpkjADWiZg",
    "https://www.youtube.com/watch?v=5Am7UPjKNFA",
    "https://www.youtube.com/watch?v=GhisJtqwEhw",
    "https://www.youtube.com/watch?v=I9zvdOcdXgI",
    "https://www.youtube.com/watch?v=6I6pSeP2fhc",
    "https://www.youtube.com/watch?v=bPB-7pBE3uU",
    "https://www.youtube.com/watch?v=dY7Hm8IPXxQ",
    "https://www.youtube.com/watch?v=E967Zj51Ysg",
    "https://www.youtube.com/watch?v=SuwhQTa0HN0",
    "https://www.youtube.com/watch?v=7tg1QfR0grg",
    "https://www.youtube.com/watch?v=gy7n6Nffktc",
    "https://www.youtube.com/watch?v=RD8wZtvFzdc",
    "https://www.youtube.com/watch?v=H1_OlvEuR5U",
    "https://www.youtube.com/watch?v=0Ll5-gURs6w",
    "https://www.youtube.com/watch?v=e-TMzIJcVjc"
)

$total   = $urls.Count
$success = 0
$skipped = 0

Write-Host ""
Write-Host "=== Processing $total videos ===" -ForegroundColor Cyan
Write-Host "Output directory: $outputDir"
Write-Host ""

for ($i = 0; $i -lt $urls.Count; $i++) {
    $url = $urls[$i]
    $num = $i + 1
    Write-Host "[$num/$total] $url" -ForegroundColor Yellow

    python $scriptPath $url --lang ru --output-dir $outputDir

    if ($LASTEXITCODE -eq 0) {
        $success++
    } else {
        $skipped++
        Write-Host "  -> skipped (no subtitles or error)" -ForegroundColor DarkGray
    }

    Write-Host ""
}

Write-Host "=== Done ===" -ForegroundColor Green
Write-Host "Done: $success  |  Skipped: $skipped  |  Total: $total"
Write-Host "Files: $outputDir"
