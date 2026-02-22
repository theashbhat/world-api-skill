---
name: world-api
description: Query real-time world news by location, topic, or region via the World API.
triggers:
  - what's happening
  - news near
  - news in
  - what happened
  - breaking news
---

# World API Skill

Query real-time world news and reports by location, topic, or region.

## Setup

Run the setup script to configure your API key:
```bash
./scripts/setup.sh
```

## Usage

### Query by Location (Lat/Lon/Radius)

Get news within a radius of a specific coordinate:
```bash
./scripts/query.sh --lat 37.7749 --lon -122.4194 --radius 50
```
- `--lat` - Latitude (required with --lon)
- `--lon` - Longitude (required with --lat)
- `--radius` - Radius in kilometers (default: 25)

### Query by City/Country/State

Get news for a specific location by name:
```bash
# By city
./scripts/query.sh --city "San Francisco"

# By country
./scripts/query.sh --country "United States"

# By state
./scripts/query.sh --state "California"

# Combined
./scripts/query.sh --city "Austin" --state "Texas" --country "United States"
```

### Query by Category

Filter news by topic category:
```bash
./scripts/query.sh --category politics
./scripts/query.sh --category tech
./scripts/query.sh --category health
./scripts/query.sh --city "New York" --category business
```

Available categories:
- `politics` - Political news and government
- `tech` - Technology and innovation
- `health` - Healthcare and medical news
- `business` - Business and economics
- `science` - Scientific discoveries
- `sports` - Sports news
- `entertainment` - Entertainment and culture
- `environment` - Climate and environment

### Query by Time Range

Get news from a specific time period:
```bash
# Last 24 hours
./scripts/query.sh --hours 24

# Last week
./scripts/query.sh --hours 168

# Combined with location
./scripts/query.sh --city "London" --hours 48
```

### Search by Text Term

Search for specific keywords:
```bash
./scripts/query.sh --term "earthquake"
./scripts/query.sh --term "election" --country "France"
./scripts/query.sh --term "AI" --category tech --hours 72
```

### Limit Results

Control how many results to return:
```bash
./scripts/query.sh --city "Tokyo" --limit 5
./scripts/query.sh --term "climate" --limit 20
```

## Example Queries

### "What's happening in San Francisco?"
```bash
./scripts/query.sh --city "San Francisco" --hours 24 --limit 10
```

### "Breaking news about tech in California"
```bash
./scripts/query.sh --state "California" --category tech --hours 12
```

### "News near me" (with coordinates)
```bash
./scripts/query.sh --lat 40.7128 --lon -74.0060 --radius 30 --hours 24
```

### "What happened in Europe about climate?"
```bash
./scripts/query.sh --term "climate" --hours 48 --limit 15
```

## API Reference

**Endpoint:** `https://api.worldapi.com/reports`

**Authentication:** Bearer token in header

**Query Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| lat | float | Latitude coordinate |
| lon | float | Longitude coordinate |
| radius | int | Search radius in km |
| city | string | City name |
| country | string | Country name |
| state | string | State/province name |
| category | string | News category |
| term | string | Search term |
| min_time | ISO8601 | Start of time range |
| max_time | ISO8601 | End of time range |
| limit | int | Max results (default: 10) |
| offset | int | Pagination offset |

## Response Format

```json
{
  "reports": [
    {
      "id": "abc123",
      "title": "Major Development in Downtown Area",
      "summary": "Brief description of the news...",
      "category": "politics",
      "location": {
        "city": "San Francisco",
        "state": "California",
        "country": "United States",
        "lat": 37.7749,
        "lon": -122.4194
      },
      "published_at": "2026-02-22T01:30:00Z",
      "source": "News Outlet",
      "url": "https://..."
    }
  ],
  "total": 42,
  "offset": 0,
  "limit": 10
}
```

## Configuration

API key is stored at: `~/.config/world-api/api_key`

To update your API key:
```bash
./scripts/setup.sh
```

Or manually:
```bash
echo "your-api-key" > ~/.config/world-api/api_key
chmod 600 ~/.config/world-api/api_key
```
