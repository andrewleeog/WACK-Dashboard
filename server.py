from flask import Flask, send_file, request, jsonify
import sqlite3
import pandas as pd
import io
import os

app = Flask(__name__)
DB_FILE = 'wack.db'

def init_db():
    """Load CSV data into SQLite database"""
    conn = sqlite3.connect(DB_FILE)
    conn.execute('DROP TABLE IF EXISTS camper')
    conn.execute('DROP TABLE IF EXISTS sponsor')
    
    camper = pd.read_csv('campers.csv')
    camper['Name'] = camper["Child - Person's Name - First Name"] + ' ' + camper["Child - Person's Name - Last Name"]
    camper['Gender'] = camper['Child - Gender']
    camper['Grade'] = camper['Child - Last Grade Completed']
    camper['Medical Info'] = camper['Child - Medical Information/Allergies']
    camper['Church'] = camper.apply(lambda x: x['Child - Church Name'] if x['Child - Church'] == 'Other' else x['Child - Church'], axis=1)
    track_map = {
        'PHOTOGRAPHY (must bring a digital camera)': 'PHOTOGRAPHY',
        'STOMP (must bring drum sticks)': 'STOMP',
        'Selected for Speaking Drama Role': 'DRAMA'
    }
    camper['Track'] = camper['Child - Track Assignment'].replace(track_map)
    camper['Size'] = camper['Child - T-Shirt Size']
    camper['Email'] = camper['Email']
    camper.to_sql('camper', conn, index=False, if_exists='replace')
    
    sponsor = pd.read_csv('sponsors.csv')
    sponsor['Name'] = sponsor["Sponsor - Person's Name - First Name"] + ' ' + sponsor["Sponsor - Person's Name - Last Name"]
    sponsor['Gender'] = sponsor['Sponsor - Gender']
    sponsor['Church'] = sponsor.apply(lambda x: x['Sponsor - Church Name'] if x['Sponsor - Church'] == 'Other' else x['Sponsor - Church'], axis=1)
    sponsor['Type'] = sponsor['Sponsor - ']
    sponsor['Size'] = sponsor['Sponsor - T-Shirt Size']
    sponsor['Email'] = sponsor['Email']
    sponsor['Job Preference'] = sponsor['Sponsor - Preferred Job Assignment']
    sponsor['Job Details'] = sponsor['Sponsor - Preferred Job Assignment Details']
    sponsor.to_sql('sponsor', conn, index=False, if_exists='replace')
    
    conn.close()
    return DB_FILE

@app.route('/api/query', methods=['POST'])
def query():
    """Execute SQL query and return results"""
    data = request.json
    query = data.get('query', '')
    
    if not os.path.exists(DB_FILE):
        init_db()
    
    conn = sqlite3.connect(DB_FILE)
    conn.row_factory = sqlite3.Row
    cursor = conn.cursor()
    
    try:
        cursor.execute(query)
        if query.strip().upper().startswith('SELECT'):
            rows = cursor.fetchall()
            columns = [desc[0] for desc in cursor.description] if cursor.description else []
            results = [dict(row) for row in rows]
            conn.close()
            return jsonify({'columns': columns, 'results': results})
        else:
            conn.commit()
            conn.close()
            return jsonify({'success': True})
    except Exception as e:
        conn.close()
        return jsonify({'error': str(e)})

@app.route('/api/save', methods=['POST'])
def save_db():
    """Save the database to disk"""
    try:
        init_db()
        return jsonify({'success': True})
    except Exception as e:
        return jsonify({'error': str(e)})

@app.route('/')
def index():
    return send_file('dashboard.html')

@app.route('/')
def serve_file(filename):
    return send_file(filename)

if __name__ == '__main__':
    if not os.path.exists(DB_FILE):
        print("Initializing database...")
        init_db()
        print("Database created!")
    print("Starting server at http://localhost:8000")
    app.run(port=8000, debug=True)