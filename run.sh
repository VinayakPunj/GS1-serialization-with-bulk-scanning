#!/usr/bin/env bash
# Usage:  ./run.sh          run the demo on the sample data
#         ./run.sh test     run the unit tests
#         ./run.sh scale    generate and reconcile 500 synthetic shipments
set -euo pipefail
cd "$(dirname "$0")"

PY="${PYTHON:-python3}"
if ! command -v "$PY" >/dev/null 2>&1; then
  echo "Python 3.9 or newer is required. Install it from https://www.python.org/downloads/" >&2
  exit 1
fi

case "${1:-demo}" in
  test)
    "$PY" -m unittest discover -s tests -v
    ;;
  scale)
    "$PY" -m gs1demo generate --shipments 500 --out outputs/scale_data
    "$PY" -m gs1demo run --scans outputs/scale_data/scans.csv \
      --record outputs/scale_data/system_of_record.csv --out outputs/scale_report
    ;;
  demo)
    "$PY" -m gs1demo demo
    ;;
  *)
    echo "Unknown option '$1'. Use: demo, test or scale." >&2
    exit 1
    ;;
esac
