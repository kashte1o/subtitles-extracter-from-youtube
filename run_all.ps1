$scriptPath = "$PSScriptRoot\extract.py"
$outputDir  = "$PSScriptRoot\transcripts"

$urls = @(
    "https://www.youtube.com/watch?v=Tbuz4CWQH5o",   # 1  MACD
    "https://youtu.be/0cBkmyekqP8",                   # 2  RSI
    "https://www.youtube.com/watch?v=w8F8kFZRPHY",   # 3  Стратегия СЛ/ТП
    "https://www.youtube.com/watch?v=0BSLahvt6tg",   # 3.1 Трейлинг стоп
    "https://www.youtube.com/watch?v=muXyB9MOe2g",   # 4  Усреднение
    "https://www.youtube.com/watch?v=JsLkgQRmtj0",   # 5  Импульсы
    "https://www.youtube.com/watch?v=LUkMCGF64RU",   # 6  EMA
    "https://www.youtube.com/watch?v=htpibHXR-CQ",   # 7  Дивергенция
    "https://www.youtube.com/watch?v=QTXvqEr8kpA",   # 8  VumanChu Cipher B
    "https://www.youtube.com/watch?v=sxn76XWf5fg",   # 9  Фибоначчи
    "https://www.youtube.com/watch?v=c_Kk3vTkAGU",   # 10 Справка
    "https://www.youtube.com/watch?v=b_8WU4s_uSW",   # 11 Поддержка/сопротивление
    "https://www.youtube.com/watch?v=E4olma5KqJA",   # 12 Отскоки
    "https://www.youtube.com/watch?v=Y-hNJ1-kDy4",   # 13 Суточная стратегия
    "https://www.youtube.com/watch?v=yM3UIQ4PQCc",   # 14 Два осциллятора
    "https://www.youtube.com/watch?v=tQbO_M4lwfw",   # 15 HH/LH + Боллинджер
    "https://www.youtube.com/watch?v=MIBbZabs9Qw",   # 16 Зона дисбаланса
    "https://www.youtube.com/watch?v=m59yIO50ua8",   # 17 Хеджирование
    "https://www.youtube.com/watch?v=c_JZVZPpYNg",   # 18 Зоны и цели
    "https://www.youtube.com/watch?v=PL_EG6VSaCE",   # 19 Стохастик RSI
    "https://www.youtube.com/watch?v=LwRjkqCm4BE",   # 20 Денежный поток 3 ТФ
    "https://www.youtube.com/watch?v=NLpkjADWiZg",   # 21 Дельта объёмов
    "https://www.youtube.com/watch?v=5Am7UPjKNFA",   # 22 Индикатор тренда
    "https://www.youtube.com/watch?v=GhisJtqwEhw",   # 23 Кризисный момент
    "https://www.youtube.com/watch?v=I9zvdOcdXgI",   # 24 Комплексный анализ
    "https://www.youtube.com/watch?v=6I6pSeP2fhc",   # 25 Стратегия май
    "https://www.youtube.com/watch?v=bPB-7pBE3uU",   # 26 Всегда в сделке
    "https://www.youtube.com/watch?v=dY7Hm8IPXxQ",   # 27 Продвинутая поддержка
    "https://www.youtube.com/watch?v=E967Zj51Ysg",   # 28 Зоны дисбаланса 2
    "https://www.youtube.com/watch?v=SuwhQTa0HN0",   # 29 Индикатор волатильности
    "https://www.youtube.com/watch?v=7tg1QfR0grg",   # 30 Торговля по трендам
    "https://www.youtube.com/watch?v=gy7n6Nffktc",   # 31 Продвинутый RSI
    "https://www.youtube.com/watch?v=RD8wZtvFzdc",   # 32 Хеджирование-копилка
    "https://www.youtube.com/watch?v=H1_OlvEuR5U",   # 33 Объёмы
    "https://www.youtube.com/watch?v=0Ll5-gURs6w",   # 34 Денежный поток
    "https://www.youtube.com/watch?v=e-TMzIJcVjc"    # 35 Канальный анализ
)

$total   = $urls.Count
$success = 0
$skipped = 0

Write-Host ""
Write-Host "=== Запуск обработки $total видео ===" -ForegroundColor Cyan
Write-Host "Результаты будут сохранены в: $outputDir"
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
        Write-Host "  -> пропущено (нет субтитров или ошибка)" -ForegroundColor DarkGray
    }

    Write-Host ""
}

Write-Host "=== Готово ===" -ForegroundColor Green
Write-Host "Обработано: $success  |  Пропущено: $skipped  |  Всего: $total"
Write-Host "Файлы: $outputDir"
