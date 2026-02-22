#!/bin/bash
# World API Digest Generator
# Generate a news digest based on tracked interests

CONFIG_DIR="$HOME/.config/world-api"
API_KEY_FILE="$CONFIG_DIR/api_key"
INTERESTS_FILE="$CONFIG_DIR/interests.json"
SCRIPT_DIR="$(dirname "$0")"

# Check for API key
if [ ! -f "$API_KEY_FILE" ]; then
    echo "No API key configured. Run setup.sh first."
    exit 1
fi

# Check for interests
if [ ! -f "$INTERESTS_FILE" ]; then
    echo "No interests tracked yet. Use interests.sh to add some."
    exit 1
fi

API_KEY=$(cat "$API_KEY_FILE")
HOURS=${1:-12}  # Default to last 12 hours

echo "📰 World API News Digest"
echo "========================"
echo ""

# Query for each location
for location in $(jq -r '.locations[]' "$INTERESTS_FILE" 2>/dev/null); do
    echo "📍 $location"
    "$SCRIPT_DIR/query.sh" --city "$location" --hours "$HOURS" --limit 3 2>/dev/null | grep -A2 "^\[0;32m" | head -12
    echo ""
done

# Query for each topic
for topic in $(jq -r '.topics[]' "$INTERESTS_FILE" 2>/dev/null); do
    echo "🏷️ $topic"
    "$SCRIPT_DIR/query.sh" --category "$topic" --hours "$HOURS" --limit 3 2>/dev/null | grep -A2 "^\[0;32m" | head -12
    echo ""
done

# Query for each term
for term in $(jq -r '.terms[]' "$INTERESTS_FILE" 2>/dev/null); do
    echo "🔍 $term"
    "$SCRIPT_DIR/query.sh" --term "$term" --hours "$HOURS" --limit 3 2>/dev/null | grep -A2 "^\[0;32m" | head -12
    echo ""
done

# Update last check time
"$SCRIPT_DIR/interests.sh" update-check

echo "---"
echo "Manage interests: ./scripts/interests.sh list"
