# WACK Registration Dashboard

An HTML dashboard for querying camper and sponsor registration data from SQLite, with Excel export capabilities.

## Quick Start

1. Start a local web server:
   ```bash
   python -m http.server 8000
   ```

2. Open the dashboard:
   ```
   http://localhost:8000/dashboard.html
   ```

## Features

- **Refresh**: Loads data from CSV files and applies formatting
- **Clear**: Resets all filters
- **Export Current**: Exports filtered results to Excel
- **Export Full**: Creates organized Excel reports by Church and Track

## Data Layout

- 35% Left sidebar: Filters + Actions
- 65% Right: Results + T-Shirt Size Breakdown

## Files

- `dashboard.html` - Main dashboard
- `wack.db` - SQLite database (auto-generated)
- `wack_registration.R` - R script for Excel reports
- `WACK_2025_Camper_Registration (1).csv` - Camper data
- `WACK_2025_Sponsor_Registration (1).csv` - Sponsor data