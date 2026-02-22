# World API Skill

Query real-time world news by location, topic, or region via the World API.

## Features

- 🌍 **Location-based queries** - Search by coordinates, city, state, or country
- 📰 **Category filtering** - Filter by politics, tech, health, business, etc.
- 🔍 **Text search** - Find news containing specific keywords
- ⏰ **Time range** - Get news from the last N hours
- 📊 **Formatted output** - Clean, readable results

## Installation

1. Clone this repository:
```bash
git clone https://github.com/theashbhat/world-api-skill.git
cd world-api-skill
```

2. Run setup to configure your API key:
```bash
./scripts/setup.sh
```

3. Make scripts executable (if needed):
```bash
chmod +x scripts/*.sh
```

## Quick Start

```bash
# What's happening in San Francisco?
./scripts/query.sh --city "San Francisco"

# Tech news from the last 24 hours
./scripts/query.sh --category tech --hours 24

# News near a location (lat/lon)
./scripts/query.sh --lat 40.7128 --lon -74.0060 --radius 25

# Search for specific topics
./scripts/query.sh --term "earthquake" --limit 10

# Combined query
./scripts/query.sh --city "London" --category politics --hours 48 --limit 5
```

## Usage

See [SKILL.md](SKILL.md) for complete documentation including:
- All available query parameters
- Example queries for common use cases
- API response format
- Configuration options

## API

This skill uses the World API:
- **Endpoint:** `https://api.worldapi.com/reports`
- **Auth:** Bearer token
- **Docs:** See [SKILL.md](SKILL.md) for parameter reference

## Configuration

API key location: `~/.config/world-api/api_key`

To update your key, run `./scripts/setup.sh` or manually update the file.

## License

MIT
