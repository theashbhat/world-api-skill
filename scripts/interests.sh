#!/bin/bash
# World API Interests Manager
# Track topics for proactive news updates

CONFIG_DIR="$HOME/.config/world-api"
INTERESTS_FILE="$CONFIG_DIR/interests.json"

# Ensure config directory exists
mkdir -p "$CONFIG_DIR"

# Initialize interests file if it doesn't exist
if [ ! -f "$INTERESTS_FILE" ]; then
    echo '{"locations":[],"topics":[],"terms":[],"last_check":null}' > "$INTERESTS_FILE"
fi

case "$1" in
    add-location)
        jq --arg loc "$2" '.locations += [$loc] | .locations |= unique' "$INTERESTS_FILE" > "$INTERESTS_FILE.tmp" && mv "$INTERESTS_FILE.tmp" "$INTERESTS_FILE"
        echo "Added location: $2"
        ;;
    add-topic)
        jq --arg topic "$2" '.topics += [$topic] | .topics |= unique' "$INTERESTS_FILE" > "$INTERESTS_FILE.tmp" && mv "$INTERESTS_FILE.tmp" "$INTERESTS_FILE"
        echo "Added topic: $2"
        ;;
    add-term)
        jq --arg term "$2" '.terms += [$term] | .terms |= unique' "$INTERESTS_FILE" > "$INTERESTS_FILE.tmp" && mv "$INTERESTS_FILE.tmp" "$INTERESTS_FILE"
        echo "Added term: $2"
        ;;
    remove-location)
        jq --arg loc "$2" '.locations -= [$loc]' "$INTERESTS_FILE" > "$INTERESTS_FILE.tmp" && mv "$INTERESTS_FILE.tmp" "$INTERESTS_FILE"
        echo "Removed location: $2"
        ;;
    remove-topic)
        jq --arg topic "$2" '.topics -= [$topic]' "$INTERESTS_FILE" > "$INTERESTS_FILE.tmp" && mv "$INTERESTS_FILE.tmp" "$INTERESTS_FILE"
        echo "Removed topic: $2"
        ;;
    remove-term)
        jq --arg term "$2" '.terms -= [$term]' "$INTERESTS_FILE" > "$INTERESTS_FILE.tmp" && mv "$INTERESTS_FILE.tmp" "$INTERESTS_FILE"
        echo "Removed term: $2"
        ;;
    list)
        echo "📍 Locations:"
        jq -r '.locations[]' "$INTERESTS_FILE" 2>/dev/null | sed 's/^/  • /'
        echo "📰 Topics:"
        jq -r '.topics[]' "$INTERESTS_FILE" 2>/dev/null | sed 's/^/  • /'
        echo "🔍 Terms:"
        jq -r '.terms[]' "$INTERESTS_FILE" 2>/dev/null | sed 's/^/  • /'
        echo ""
        echo "Last check: $(jq -r '.last_check // "never"' "$INTERESTS_FILE")"
        ;;
    clear)
        echo '{"locations":[],"topics":[],"terms":[],"last_check":null}' > "$INTERESTS_FILE"
        echo "Cleared all interests"
        ;;
    update-check)
        jq --arg time "$(date -u +%Y-%m-%dT%H:%M:%SZ)" '.last_check = $time' "$INTERESTS_FILE" > "$INTERESTS_FILE.tmp" && mv "$INTERESTS_FILE.tmp" "$INTERESTS_FILE"
        ;;
    *)
        echo "Usage: interests.sh <command> [value]"
        echo ""
        echo "Commands:"
        echo "  add-location <city>    Add a location to track"
        echo "  add-topic <topic>      Add a topic (tech, politics, health, etc.)"
        echo "  add-term <term>        Add a search term"
        echo "  remove-location <city> Remove a location"
        echo "  remove-topic <topic>   Remove a topic"
        echo "  remove-term <term>     Remove a term"
        echo "  list                   Show all tracked interests"
        echo "  clear                  Clear all interests"
        ;;
esac
