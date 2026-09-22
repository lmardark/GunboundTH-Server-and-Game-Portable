#!/usr/bin/env bash

set -u

APP_ID="com.usebottles.bottles"
NOME_GARRAFA="Gunbound"
DIRETORIO_CLIENTE="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DIRETORIO_ARQUIVOS="$DIRETORIO_CLIENTE/Arquivos"
ARQUIVO_ID="$DIRETORIO_ARQUIVOS/ID.txt"
INSTALADOR_DOTNET="$DIRETORIO_ARQUIVOS/Apps e Softwares/dotNetFx40_Full_x86_x64.exe"
EXECUTAVEL_GUNBOUND="$DIRETORIO_ARQUIVOS/GunBound.exe"
EXECUTAVEL_DXWND="$DIRETORIO_ARQUIVOS/dxwnd.exe"
MARCADOR_DOTNET="$DIRETORIO_CLIENTE/.dotnet40-instalado"

erro() {
    printf '\nERRO: %s\n' "$1" >&2
    exit 1
}

criar_id() {
    local id=""

    if [ -s "$ARQUIVO_ID" ]; then
        return
    fi

    printf '%s\n' "========================================"
    printf '%s\n' "        Gunbound Thor Hammer"
    printf '%s\n' "========================================"

    while true; do
        printf 'Qual sera seu ID no Gunbound? '
        read -r id
        if [[ "$id" =~ ^[[:alnum:]]{3,12}$ ]]; then
            printf '%s\n' "$id" > "$ARQUIVO_ID"
            return
        fi
        printf '%s\n' "Use de 3 a 12 letras ou numeros, sem espacos ou acentos."
    done
}

command -v flatpak >/dev/null 2>&1 || erro "O Flatpak nao esta instalado. Consulte o README incluido no projeto."
flatpak info "$APP_ID" >/dev/null 2>&1 || erro "Instale o Bottles com: flatpak install flathub $APP_ID"
[ -d "$DIRETORIO_ARQUIVOS" ] || erro "A pasta Arquivos nao foi encontrada ao lado deste script."
[ -f "$INSTALADOR_DOTNET" ] || erro "O instalador do .NET Framework nao foi encontrado."
[ -f "$EXECUTAVEL_GUNBOUND" ] || erro "O GunBound.exe nao foi encontrado."

criar_id

# O Bottles e isolado pelo Flatpak. Libera somente esta pasta do cliente.
flatpak override --user --filesystem="$DIRETORIO_CLIENTE" "$APP_ID" || \
    erro "Nao foi possivel liberar a pasta do cliente para o Bottles."

BOTTLES_CLI=(flatpak run --command=bottles-cli "$APP_ID")

if ! "${BOTTLES_CLI[@]}" list bottles 2>/dev/null | grep -Fq "$NOME_GARRAFA"; then
    printf '%s\n' "Criando a garrafa 32-bit do Gunbound no Bottles..."
    if ! "${BOTTLES_CLI[@]}" new \
        --bottle-name "$NOME_GARRAFA" \
        --environment gaming \
        --arch win32; then
        printf '%s\n' ""
        printf '%s\n' "O Bottles precisa concluir a configuracao inicial."
        printf '%s\n' "Na janela que sera aberta, aguarde os componentes terminarem de baixar."
        printf '%s\n' "Se necessario, crie uma garrafa 32-bit chamada Gunbound e rode este script novamente."
        flatpak run "$APP_ID"
        exit 1
    fi
fi

# O ambiente "Jogos" ativa DXVK/VKD3D por padrao. Este cliente de 2004 usa
# DirectX legado pelo DxWnd e apresenta paleta/tela corrompida com DXVK.
printf '%s\n' "Configurando WineD3D para o DirectX antigo do Gunbound..."
"${BOTTLES_CLI[@]}" edit \
    -b "$NOME_GARRAFA" \
    --params "dxvk:false,vkd3d:false" || \
    erro "Nao foi possivel desativar DXVK/VKD3D na garrafa."

if [ ! -f "$MARCADOR_DOTNET" ]; then
    printf '%s\n' "Abrindo o instalador do .NET Framework 4.0..."
    "${BOTTLES_CLI[@]}" run -b "$NOME_GARRAFA" -e "$INSTALADOR_DOTNET" || \
        erro "A instalacao do .NET Framework falhou ou foi cancelada."
    touch "$MARCADOR_DOTNET" || erro "Nao foi possivel salvar o estado da instalacao do .NET."
fi

if [ "${1:-}" = "--dxwnd" ]; then
    [ -f "$EXECUTAVEL_DXWND" ] || erro "O dxwnd.exe nao foi encontrado."
    printf '%s\n' "Abrindo o DxWnd no modo de compatibilidade manual..."
    printf '%s\n' "Na janela do DxWnd, de dois cliques em GunBound."
    "${BOTTLES_CLI[@]}" run -b "$NOME_GARRAFA" -e "$EXECUTAVEL_DXWND" || \
        erro "Nao foi possivel abrir o DxWnd."
else
    # No Wine, o hook de DirectDraw do DxWnd corrompe a paleta deste cliente.
    # O launcher ja configura IP, registro e credenciais antes de iniciar o .gme.
    printf '%s\n' "Abrindo o Gunbound diretamente pelo WineD3D..."
    "${BOTTLES_CLI[@]}" run -b "$NOME_GARRAFA" -e "$EXECUTAVEL_GUNBOUND" || \
        erro "Nao foi possivel abrir o Gunbound."
fi
