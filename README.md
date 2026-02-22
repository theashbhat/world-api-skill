# World API Skill

Query real-time world news by location, topic, or region via the World API.

## Features

- 🌍 **Location-based queries** - Search by coordinates, city, state, or country
- 📰 **Category filtering** - Filter by politics, tech, health, business, etc.
- 🔍 **Text search** - Find news containing specific keywords
- ⏰ **Time range** - Get news from the last N hours
- 📊 **Formatted output** - Clean, readable results

## Installation

### OpenClaw / Claude Code

```bash
# Install from GitHub
clawhub install github:theashbhat/world-api-skill
```

Or add to your skills directory:
```bash
cd ~/clawd/skills  # or your workspace skills folder
git clone https://github.com/theashbhat/world-api-skill.git world-api
```

Then run setup:
```bash
./world-api/scripts/setup.sh
```

### Manual Installation

```bash
git clone https://github.com/theashbhat/world-api-skill.git
cd world-api-skill
./scripts/setup.sh
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

Once installed, just ask:
- "What's happening in San Francisco?"
- "Tech news today"
- "News near me"
- "What happened in Washington DC?"

See [SKILL.md](SKILL.md) for complete documentation.

## API

- **Endpoint:** `https://api.worldapi.com/reports`
- **Auth:** Bearer token
- **Get a key:** [worldapi.com](https://worldapi.com) (coming soon)

## Configuration

API key location: `~/.config/world-api/api_key`

## License

MIT
