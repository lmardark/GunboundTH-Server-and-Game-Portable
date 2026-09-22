#!/usr/bin/env bash
# Sobe o servidor de Gunbound Thor Hammer em Linux/Mac.
set -e
cd "$(dirname "$0")"

echo "=============================================================================="
echo " Ligando o servidor de Gunbound (Linux/Mac)..."
echo "=============================================================================="

# --- 1. Python + dependencias -------------------------------------------------
if [ ! -d venv ]; then
    python3 -m venv venv
fi
source venv/bin/activate
python3 -c "from Crypto.Cipher import AES" 2>/dev/null || pip install -q pycryptodome

# --- 2. Extrai o cliente do jogo (uma vez só) ----------------------------------
CLIENT_ZIP="HTTP/client/ZIP_GunboundCliente.zip"
if [ ! -f "$CLIENT_ZIP" ]; then
    echo " Extraindo o cliente do jogo (client.part*.rar)..."
    if command -v 7z >/dev/null; then
        7z x -y -o"HTTP/client" "HTTP/client/client.part01.rar" >/dev/null
    elif command -v unar >/dev/null; then
        unar -f -o "HTTP/client" "HTTP/client/client.part01.rar" >/dev/null
    else
        echo " ERRO: instale '7z' (p7zip) ou 'unar' para extrair o cliente do jogo."
        exit 1
    fi
fi

# --- 3. Prepara a pasta servida pelo site de download --------------------------
GBTH_DIR="GBTH"
mkdir -p "$GBTH_DIR"
cp -f "$CLIENT_ZIP" "$GBTH_DIR/"
cp -f HTTP/modules/mod_index.so "$GBTH_DIR/index.php"

IP=$(python3 -c "import socket; s=socket.socket(socket.AF_INET, socket.SOCK_DGRAM); s.connect(('8.8.8.8', 80)); print(s.getsockname()[0])")
echo -n "$IP" > "$GBTH_DIR/IP.txt"

# --- 4. Sobe o site de download (PHP embutido) ----------------------------------
if ! command -v php >/dev/null; then
    echo " ERRO: instale o PHP (ex: sudo apt install php-cli / brew install php)."
    exit 1
fi

start_php_server() {
    local port="$1"
    local log="/tmp/gbth_php_$$.log"
    php -d display_errors=0 -S "0.0.0.0:$port" -t "$GBTH_DIR" >"$log" 2>&1 &
    HTTP_PID=$!
    sleep 0.5
    if kill -0 "$HTTP_PID" 2>/dev/null && grep -q "Development Server" "$log"; then
        rm -f "$log"
        return 0
    fi
    kill "$HTTP_PID" 2>/dev/null || true
    rm -f "$log"
    return 1
}

if start_php_server 80; then
    URL="http://$IP/"
else
    echo " Porta 80 indisponivel (em uso ou sem privilegios), usando a porta 8080..."
    if ! start_php_server 8080; then
        echo " ERRO: nao foi possivel subir o site de download nem na porta 8080."
        exit 1
    fi
    URL="http://$IP:8080/"
fi
trap 'kill "$HTTP_PID" 2>/dev/null' EXIT

echo "=============================================================================="
echo " SERVIDOR DE GUNBOUND LIGADO! IP: $IP"
echo " Os jogadores devem acessar $URL para baixar o jogo."
echo " O cliente baixado e um .exe: em Linux/Mac use o Wine para jogar."
echo "=============================================================================="

# --- 5. Sobe o servidor do jogo (primeiro plano) --------------------------------
python3 Scripts.py
