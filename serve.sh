#!/bin/bash
echo "🌐 Bitcoin Family Office dev site running at http://localhost:8888"
echo "   Press Ctrl+C to stop"
cd "$(dirname "$0")"
python3 -m http.server 8888
