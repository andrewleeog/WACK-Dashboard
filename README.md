# WACK Registration Dashboard

An HTML dashboard with Python Flask backend for querying camper and sponsor registration data from SQLite.

## Quick Start

1. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

2. Run the server:
   ```bash
   python server.py
   ```

3. Open the dashboard:
   ```
   http://localhost:8000
   ```

## Features

- **Refresh**: Loads data from CSV files and saves to wack.db
- **Clear**: Resets all filters
- **Export Current**: Exports filtered results to Excel
- **Export Full**: Creates organized Excel reports by Church and Track

## Data Layout

- 35% Left sidebar: Filters + Actions
- 65% Right: Results + T-Shirt Size Breakdown

## Files

- `server.py` - Flask backend server
- `dashboard.html` - Frontend dashboard
- `wack_registration.py` - Standalone Python script for Excel reports
- `requirements.txt` - Python dependencies