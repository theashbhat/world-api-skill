#!/bin/bash
# World API Query Script
# Query real-time world news by location, topic, or region

set -e

# Configuration
API_KEY_FILE="$HOME/.config/world-api/api_key"
API_ENDPOINT="https://api.worldapi.com/reports"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
LIMIT=10
RADIUS=""
HOURS=""
LAT=""
LON=""
CITY=""
COUNTRY=""
STATE=""
CATEGORY=""
SEARCH_TERM=""  # Using SEARCH_TERM instead of TERM (TERM is a shell reserved var)

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --lat)
            LAT="$2"
            shift 2
            ;;
        --lon)
            LON="$2"
            shift 2
            ;;
        --radius)
            RADIUS="$2"
            shift 2
            ;;
        --city)
            CITY="$2"
            shift 2
            ;;
        --country)
            COUNTRY="$2"
            shift 2
            ;;
        --state)
            STATE="$2"
            shift 2
            ;;
        --category)
            CATEGORY="$2"
            shift 2
            ;;
        --term)
            SEARCH_TERM="$2"
            shift 2
            ;;
        --hours)
            HOURS="$2"
            shift 2
            ;;
        --limit)
            LIMIT="$2"
            shift 2
            ;;
        --help|-h)
            echo "Usage: query.sh [OPTIONS]"
            echo ""
            echo "Location Options:"
            echo "  --lat LATITUDE      Latitude coordinate"
            echo "  --lon LONGITUDE     Longitude coordinate"
            echo "  --radius KM         Search radius in kilometers"
            echo "  --city NAME         City name"
            echo "  --country NAME      Country name"
            echo "  --state NAME        State/province name"
            echo ""
            echo "Filter Options:"
            echo "  --category CAT      Category (politics, tech, health, business, etc.)"
            echo "  --term TEXT         Search term"
            echo "  --hours N           Get news from last N hours"
            echo "  --limit N           Max results (default: 10)"
            echo ""
            echo "Examples:"
            echo "  query.sh --city \"San Francisco\" --hours 24"
            echo "  query.sh --lat 37.77 --lon -122.42 --radius 50"
            echo "  query.sh --category tech --term \"AI\" --limit 20"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

# Check for API key
if [ ! -f "$API_KEY_FILE" ]; then
    echo -e "${RED}Error: API key not found at $API_KEY_FILE${NC}"
    echo "Run ./scripts/setup.sh to configure your API key"
    exit 1
fi

API_KEY=$(cat "$API_KEY_FILE")

if [ -z "$API_KEY" ]; then
    echo -e "${RED}Error: API key is empty${NC}"
    echo "Run ./scripts/setup.sh to configure your API key"
    exit 1
fi

# Build query string
QUERY_PARAMS=""

add_param() {
    if [ -n "$2" ]; then
        if [ -z "$QUERY_PARAMS" ]; then
            QUERY_PARAMS="$1=$2"
        else
            QUERY_PARAMS="$QUERY_PARAMS&$1=$2"
        fi
    fi
}

# Add location params
add_param "lat" "$LAT"
add_param "lon" "$LON"
add_param "radius" "$RADIUS"
add_param "city" "$(echo "$CITY" | sed 's/ /%20/g')"
add_param "country" "$(echo "$COUNTRY" | sed 's/ /%20/g')"
add_param "state" "$(echo "$STATE" | sed 's/ /%20/g')"

# Add filter params
add_param "category" "$CATEGORY"
add_param "term" "$(echo "$SEARCH_TERM" | sed 's/ /%20/g')"
add_param "limit" "$LIMIT"

# Calculate time range if hours specified
if [ -n "$HOURS" ]; then
    # Calculate min_time as ISO8601 timestamp
    if [[ "$OSTYPE" == "darwin"* ]]; then
        MIN_TIME=$(date -u -v-${HOURS}H +"%Y-%m-%dT%H:%M:%SZ")
    else
        MIN_TIME=$(date -u -d "$HOURS hours ago" +"%Y-%m-%dT%H:%M:%SZ")
    fi
    add_param "min_time" "$MIN_TIME"
fi

# Build full URL
if [ -n "$QUERY_PARAMS" ]; then
    URL="$API_ENDPOINT?$QUERY_PARAMS"
else
    URL="$API_ENDPOINT"
fi

# Make API request
echo -e "${BLUE}Querying World API...${NC}"

RESPONSE=$(curl -s -w "\n%{http_code}" \
    -H "Authorization: Bearer $API_KEY" \
    -H "Content-Type: application/json" \
    "$URL")

# Extract HTTP status code (last line)
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

# Check for errors
if [ "$HTTP_CODE" -ne 200 ]; then
    echo -e "${RED}Error: API returned status $HTTP_CODE${NC}"
    echo "$BODY" | jq . 2>/dev/null || echo "$BODY"
    exit 1
fi

# Parse and display results
TOTAL=$(echo "$BODY" | jq -r '.total // 0')
REPORTS=$(echo "$BODY" | jq -r '.reports // []')
COUNT=$(echo "$REPORTS" | jq 'length')

if [ "$COUNT" -eq 0 ]; then
    echo -e "${YELLOW}No reports found matching your query.${NC}"
    exit 0
fi

echo -e "${GREEN}Found $TOTAL reports (showing $COUNT):${NC}"
echo ""

# Display each report
echo "$REPORTS" | jq -c '.[]' | while read -r report; do
    TITLE=$(echo "$report" | jq -r '.title')
    SUMMARY=$(echo "$report" | jq -r '.summary // "No summary available"')
    CATEGORY=$(echo "$report" | jq -r '.category // "uncategorized"')
    CITY=$(echo "$report" | jq -r '.location.city // ""')
    STATE=$(echo "$report" | jq -r '.location.state // ""')
    COUNTRY=$(echo "$report" | jq -r '.location.country // ""')
    PUBLISHED=$(echo "$report" | jq -r '.published_at // ""')
    SOURCE=$(echo "$report" | jq -r '.source // "Unknown"')
    URL=$(echo "$report" | jq -r '.url // ""')
    
    # Build location string
    LOCATION=""
    [ -n "$CITY" ] && LOCATION="$CITY"
    [ -n "$STATE" ] && LOCATION="${LOCATION:+$LOCATION, }$STATE"
    [ -n "$COUNTRY" ] && LOCATION="${LOCATION:+$LOCATION, }$COUNTRY"
    
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}$TITLE${NC}"
    echo -e "${YELLOW}[$CATEGORY]${NC} ${LOCATION:+📍 $LOCATION}"
    echo ""
    echo "$SUMMARY"
    echo ""
    echo -e "📅 $PUBLISHED | 📰 $SOURCE"
    [ -n "$URL" ] && echo -e "🔗 $URL"
    echo ""
done

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
