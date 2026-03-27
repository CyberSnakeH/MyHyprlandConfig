#!/usr/bin/env bash
# =============================================================================
# Weather Widget Script for Waybar — Tokyo Night Rice
# Fetches current weather from wttr.in and outputs Waybar-compatible JSON
# Author: CyberSnakeLinux
# Date: 2026-03-26
# License: MIT
#
# Dependencies: curl, jq (optional, for debugging)
# Usage: Set WEATHER_LOCATION env var or defaults to Paris
# Output: JSON { "text", "tooltip", "class" } for Waybar custom module
# =============================================================================
set -euo pipefail

# Location — override via environment variable
LOCATION="${WEATHER_LOCATION:-Paris}"

# Weather condition code to Nerd Font icon mapping
# Reference: https://www.weatherapi.com/docs/weather_conditions.json
get_weather_icon() {
    local code="${1:-0}"
    case "$code" in
        # Clear / Sunny
        113)        echo "" ;;    # Clear
        116)        echo "" ;;    # Partly cloudy
        # Cloudy
        119)        echo "" ;;    # Cloudy
        122)        echo "" ;;    # Overcast
        # Fog / Mist
        143|248|260) echo "" ;;   # Mist / Fog / Freezing fog
        # Rain — light
        176|263|266|281|284|293|296)
                    echo "" ;;    # Light rain / drizzle / sleet
        # Rain — moderate to heavy
        299|302|305|308|311|314|317|320|350|353|356|359|362|365)
                    echo "" ;;    # Rain / heavy rain / sleet
        # Snow
        179|182|185|227|230|323|326|329|332|335|338|368|371|374|377)
                    echo "󰼶" ;;   # Snow / blizzard / ice
        # Thunderstorm
        200|386|389|392|395)
                    echo "" ;;    # Thunder / lightning
        # Fallback
        *)          echo "" ;;
    esac
}

# Fetch weather data from wttr.in (format codes: %C condition, %t temp, %h humidity, %w wind, %c code)
fetch_weather() {
    local raw
    raw=$(curl -sf --max-time 10 \
        "https://wttr.in/${LOCATION}?format=%c|%C|%t|%h|%w|%x" 2>/dev/null) || {
        echo '{"text": " N/A", "tooltip": "Weather data unavailable", "class": "error"}'
        exit 0
    }

    # Parse pipe-delimited response
    IFS='|' read -r icon_raw condition temp humidity wind code_raw <<< "$raw"

    # Clean up values — remove leading/trailing whitespace and special chars
    temp="${temp//[[:space:]]/}"
    condition="${condition#"${condition%%[![:space:]]*}"}"
    condition="${condition%"${condition##*[![:space:]]}"}"

    # Extract weather code from the raw wttr icon (last 3 digits if numeric)
    local weather_code
    weather_code=$(echo "$code_raw" | tr -dc '0-9' | tail -c 3)
    local icon
    icon=$(get_weather_icon "$weather_code")

    # If icon detection failed, use the raw wttr.in emoji stripped to a nerd font fallback
    if [[ -z "$icon" ]]; then
        icon=""
    fi

    # Build tooltip with additional details
    local tooltip
    tooltip=$(printf "%s %s\n %s\n %s\n  %s" \
        "$icon" "$condition" "$temp" "$humidity" "$wind")

    # Determine CSS class based on condition keywords
    local css_class="default"
    case "${condition,,}" in
        *rain*|*drizzle*|*shower*)   css_class="rain" ;;
        *snow*|*blizzard*|*ice*)     css_class="snow" ;;
        *thunder*|*storm*)           css_class="storm" ;;
        *clear*|*sunny*)             css_class="clear" ;;
        *cloud*|*overcast*)          css_class="cloudy" ;;
        *fog*|*mist*)                css_class="fog" ;;
    esac

    # Output valid JSON for Waybar
    printf '{"text": "%s %s", "tooltip": "%s", "class": "%s"}\n' \
        "$icon" "$temp" "$tooltip" "$css_class"
}

fetch_weather
