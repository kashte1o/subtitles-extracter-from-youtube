import re
import sys
import os
import subprocess
import argparse
from pathlib import Path


def get_video_title(url: str) -> str:
    result = subprocess.run(
        ["yt-dlp", "--print", "title", url],
        capture_output=True, text=True
    )
    title = result.stdout.strip()
    title = re.sub(r'[<>:"/\\|?*]', "_", title)
    return title or "transcript"


def download_subs(url: str, lang: str, output_dir: Path) -> Path | None:
    result = subprocess.run(
        [
            "yt-dlp",
            "--skip-download",
            "--write-subs",
            "--write-auto-subs",
            "--sub-langs", f"{lang}.*",
            "--sub-format", "vtt",
            "--convert-subs", "srt",
            "-o", str(output_dir / "subs.%(ext)s"),
            url,
        ],
        capture_output=True, text=True
    )
    if result.stdout:
        for line in result.stdout.splitlines():
            if any(k in line for k in ("[info]", "[youtube]", "Destination", "subtitle", "WARNING", "ERROR")):
                print(f"    yt-dlp: {line.strip()}")
    if result.returncode != 0 and result.stderr:
        print(f"    yt-dlp error: {result.stderr.strip()[:300]}")
    all_files = list(output_dir.glob("subs*"))
    print(f"    [debug] files in output_dir after yt-dlp: {[f.name for f in all_files]}")
    srt_files = [f for f in all_files if f.suffix == ".srt"]
    return srt_files[0] if srt_files else None


def clean_srt(srt_path: Path) -> str:
    text = srt_path.read_text(encoding="utf-8", errors="ignore")
    text = re.sub(r"^\d+\s*$", "", text, flags=re.MULTILINE)
    text = re.sub(r"^\d\d:\d\d:\d\d[,.]\d+\s-->\s.*$", "", text, flags=re.MULTILINE)
    text = re.sub(r"<[^>]+>", "", text)
    text = re.sub(r"\n+", " ", text)
    text = re.sub(r"\s+", " ", text).strip()
    return text


def download_audio(url: str, output_dir: Path) -> Path | None:
    subprocess.run(
        [
            "yt-dlp",
            "-x",
            "--audio-format", "mp3",
            "-o", str(output_dir / "audio.%(ext)s"),
            url,
        ],
        capture_output=True, text=True
    )
    audio_files = list(output_dir.glob("audio.mp3"))
    return audio_files[0] if audio_files else None


def transcribe_audio(audio_path: Path) -> str:
    from openai import OpenAI
    client = OpenAI()
    with open(audio_path, "rb") as f:
        result = client.audio.transcriptions.create(
            model="whisper-1",
            file=f,
            response_format="text",
        )
    return result


def main():
    parser = argparse.ArgumentParser(description="Extract transcript from a YouTube video")
    parser.add_argument("url", help="YouTube video URL")
    parser.add_argument("--lang", default="ru", help="Subtitle language (default: ru)")
    parser.add_argument("--force-audio", action="store_true", help="Skip subtitles, use Whisper")
    parser.add_argument("--output-dir", default=".", help="Output directory (default: .)")
    args = parser.parse_args()

    output_dir = Path(args.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    print("[*] Getting video title...")
    title = get_video_title(args.url)
    out_file = output_dir / f"transcript_{title}.txt"

    transcript = None

    if not args.force_audio:
        print(f"[*] Trying subtitles (lang: {args.lang})...")
        srt_path = download_subs(args.url, args.lang, output_dir)

        if srt_path:
            print(f"[+] Subtitles found: {srt_path.name}")
            transcript = clean_srt(srt_path)
            srt_path.unlink()
        else:
            print("[-] No subtitles found, skipping video.")
            sys.exit(0)

    if args.force_audio:
        api_key = os.getenv("OPENAI_API_KEY")
        if not api_key:
            print("[!] OPENAI_API_KEY not set. Cannot transcribe audio.")
            print("    Add it to .env or: export OPENAI_API_KEY=sk-...")
            sys.exit(1)

        print("[*] Downloading audio...")
        audio_path = download_audio(args.url, output_dir)
        if not audio_path:
            print("[!] Failed to download audio.")
            sys.exit(1)

        print("[*] Transcribing via OpenAI Whisper...")
        transcript = transcribe_audio(audio_path)
        audio_path.unlink()

    out_file.write_text(transcript, encoding="utf-8")
    print(f"\n[+] Done! Transcript saved to: {out_file}")


if __name__ == "__main__":
    env_file = Path(__file__).parent / ".env"
    if env_file.exists():
        for line in env_file.read_text().splitlines():
            if "=" in line and not line.startswith("#"):
                k, v = line.split("=", 1)
                os.environ.setdefault(k.strip(), v.strip())
    main()
