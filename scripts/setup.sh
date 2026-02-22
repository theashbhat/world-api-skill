#!/bin/bash
# World API Setup Script
# Configure API key for World API queries

set -e

# Configuration
CONFIG_DIR="$HOME/.config/world-api"
API_KEY_FILE="$CONFIG_DIR/api_key"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}World API Setup${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Create config directory if needed
if [ ! -d "$CONFIG_DIR" ]; then
    echo "Creating config directory: $CONFIG_DIR"
    mkdir -p "$CONFIG_DIR"
    chmod 700 "$CONFIG_DIR"
fi

# Check if key already exists
if [ -f "$API_KEY_FILE" ]; then
    EXISTING_KEY=$(cat "$API_KEY_FILE")
    if [ -n "$EXISTING_KEY" ]; then
        echo -e "${GREEN}✓ API key already configured${NC}"
        echo ""
        echo "Current key: ${EXISTING_KEY:0:8}...${EXISTING_KEY: -4}"
        echo ""
        read -p "Do you want to update it? (y/N) " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Keeping existing key."
            exit 0
        fi
    fi
fi

# Prompt for API key
echo ""
echo -e "${YELLOW}To get an API key:${NC}"
echo "1. Go to https://worldapi.com (or your API provider)"
echo "2. Sign up or log in"
echo "3. Navigate to API Keys / Settings"
echo "4. Generate a new API key"
echo ""

read -p "Enter your World API key: " -r API_KEY

if [ -z "$API_KEY" ]; then
    echo -e "${RED}Error: API key cannot be empty${NC}"
    exit 1
fi

# Save API key
echo "$API_KEY" > "$API_KEY_FILE"
chmod 600 "$API_KEY_FILE"

echo ""
echo -e "${GREEN}✓ API key saved to $API_KEY_FILE${NC}"
echo ""
echo "You can now use the query script:"
echo "  ./scripts/query.sh --city \"San Francisco\""
echo "  ./scripts/query.sh --category tech --hours 24"
echo ""
