#!/usr/bin/env python3
import sys
import subprocess
import json
from datetime import datetime, timezone
from xml.etree import ElementTree as ET

RSS_URL = "https://archlinux.org/feeds/news/"
MAX_ITEMS = 5


def fetch_rss():
    try:
        result = subprocess.run(
            [
                "curl",
                "-s",
                "-L",
                "--fail",
                "--connect-timeout",
                "10",
                "--max-time",
                "30",
                RSS_URL,
            ],
            capture_output=True,
            text=True,
            timeout=40,
        )
        result.check_returncode()
        return result.stdout
    except subprocess.TimeoutExpired:
        print(json.dumps({"error": "Timeout fetching RSS feed"}), file=sys.stderr)
        sys.exit(1)
    except subprocess.CalledProcessError as e:
        print(json.dumps({"error": f"Failed to fetch RSS feed: {e}"}), file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(json.dumps({"error": f"Unexpected error: {e}"}), file=sys.stderr)
        sys.exit(1)


def parse_rss(xml_content):
    try:
        root = ET.fromstring(xml_content)
        items = []

        for item in root.findall(".//item"):
            if len(items) >= MAX_ITEMS:
                break

            title_elem = item.find("title")
            link_elem = item.find("link")
            date_elem = item.find("pubDate")

            title = (title_elem.text if title_elem is not None else "No title").strip()
            url = link_elem.text if link_elem is not None else "https://archlinux.org/"
            date = date_elem.text if date_elem is not None else ""

            items.append({"title": title, "date": date, "url": url})

        return items
    except ET.ParseError as e:
        print(json.dumps({"error": f"Failed to parse XML: {e}"}), file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(json.dumps({"error": f"Failed to parse RSS: {e}"}), file=sys.stderr)
        sys.exit(1)


def main():
    xml_content = fetch_rss()
    if not xml_content:
        print(json.dumps({"error": "Empty response from RSS feed"}), file=sys.stderr)
        sys.exit(1)

    items = parse_rss(xml_content)

    result = {
        "timestamp": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"),
        "items": items,
    }

    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
