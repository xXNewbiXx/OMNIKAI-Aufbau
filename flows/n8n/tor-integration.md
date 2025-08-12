# OMNIKAI – Tor Integration Agent

Dieser Flow richtet automatisch das **Tor-Netzwerk** auf dem Host-System ein, erstellt einen **Hidden Service** für n8n und erlaubt es, Workflows **über eine Onion-Adresse** und einen KI-Agenten anonym auszuführen.

## 📂 Speicherort im Repo
- Datei: `flows/n8n/tor-integration.json`
- Anleitung: `flows/n8n/tor-integration.md` *(dieses Dokument)*

## 🚀 Funktionen
1. **Tor-Installation** (Ubuntu/Debian)
2. **Tor-Service starten** und aktivieren
3. **Hidden Service** für n8n anlegen
4. Onion-Adresse ausgeben
5. KI-Agent über Tor-Webhooks triggern

## 🛠 Voraussetzungen
- Server/VPS mit Ubuntu oder Debian
- Root- oder Sudo-Rechte
- n8n installiert
- Node.js ≥ 18.x (für Agent-Skripte)

## ⚙️ Setup
1. **Flow in n8n importieren**
   - `flows/n8n/tor-integration.json` hochladen
2. **Workflow starten**
   - Der Flow installiert und konfiguriert Tor
3. **Onion-Adresse notieren**
   - Nach dem Setup im `Setup Onion Service`-Output

## 📡 Nutzung mit KI-Agent
- KI-Agent kann die Onion-URL aufrufen, um n8n-Workflows anonym zu starten.
- Beispielcode für Agent-Anbindung:
```javascript
const axios = require('axios');
(async () => {
  await axios.post('http://<onion-url>/webhook/xyz', {}, {
    proxy: { host: '127.0.0.1', port: 9050, protocol: 'socks5' }
  });
})();
