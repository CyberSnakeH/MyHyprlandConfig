#!/usr/bin/env bash
# Apply config options through the Lua IPC API (key/value pairs).
# Values are serialized as data before being passed to hyprctl eval.
set -euo pipefail
lua=$(python3 - "$@" <<'PY'
import json
import math
import re
import sys

args = sys.argv[1:]
if not args or len(args) % 2:
    sys.exit('Usage: hypr-option.sh key value [key value ...]')
def quote(value):
    return json.dumps(value, ensure_ascii=False)
def value(text):
    if text in ('true', 'false'):
        return text
    if re.fullmatch(r'-?(?:\d+(?:\.\d*)?|\.\d+)', text):
        number = float(text)
        if not math.isfinite(number):
            raise ValueError('Non-finite config value')
        return text
    if re.fullmatch(r'(?:rgba\([0-9a-fA-F]{8}\)\s+)+\d+deg', text):
        colors = re.findall(r'rgba\([0-9a-fA-F]{8}\)', text)
        angle = re.search(r'(\d+)deg$', text)[1]
        return '{ colors = { ' + ', '.join(map(quote, colors)) + ' }, angle = ' + angle + ' }'
    return quote(text)
fields = [f'[{quote(key.replace(":", "."))}] = {value(text)}'
          for key, text in zip(args[::2], args[1::2])]
print('hl.config({ ' + ', '.join(fields) + ' })')
PY
)
hyprctl eval "$lua"
