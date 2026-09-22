# Servidor de Gunbound Thor Hammer com o Jogo incluso. 
Servidor de Gunbound Thor Hammer já pronto para ligar e jogar com seus amigos, o jogo/cliente do Gunbound está incluso!

* Ao ligar o servidor, você irá ver o IP local do seu servidor no terminal, você deve acessar o IP do servidor no navegador para baixar o jogo/cliente para entrar no Gunbound.
* Eu automatizei tudo, a criação de contas é feita na primeira vez que você logar no Gunbound, ou seja, nunca vai dar erro de conta inexistente ou login incorreto.
* Digite /help dentro do jogo para saber todos os comandos disponiveis no servidor.

# Como ligar o servidor

## Windows
Dê dois cliques em `Servidor/Ligar.bat`. Ele instala o Python e o WinRAR sozinho se precisar.

## Linux / macOS

Para hospedar o servidor, instale `python3`, `php`, a extensao PHP `ZipArchive` e `7z`.

No Debian/Ubuntu:

```bash
sudo apt update
sudo apt install python3 python3-venv php-cli php-zip p7zip-full
```

No macOS, instale primeiro o [Homebrew](https://brew.sh/) e depois:

```bash
brew install python php p7zip
```

Inicie o servidor:

```
cd Servidor
./LigarLinux.sh
```

O script extrai o cliente, sobe o site de download (com fallback automatico para a porta 8080 se a 80 estiver ocupada) e liga o servidor do jogo. Abra no navegador o endereco exibido no terminal e baixe `GunboundCliente.zip`.

# Como jogar no Linux ou macOS

O servidor funciona nativamente, mas o cliente e um programa Windows 32-bit que usa .NET Framework e DirectX. Extraia `GunboundCliente.zip` antes de continuar. O ZIP contem dois inicializadores:

- `Jogar.bat` para Windows;
- `JogarLinux.sh` para Linux.

No Windows, `Jogar.bat` configura o ID e abre o DxWnd. No Linux, `JogarLinux.sh` configura o Bottles e abre `GunBound.exe` dentro da garrafa; esse launcher configura IP, registro e credenciais antes de iniciar o jogo.

## Linux: Bottles pelo Flatpak (recomendado)

O Bottles traz o Wine e as bibliotecas 32-bit dentro do Flatpak. Assim, nao e necessario habilitar a arquitetura `i386` nem instalar `wine32` no sistema.

Este fluxo foi validado no Debian 13 (Trixie) com o Bottles instalado pelo Flathub. O jogo funcionou usando uma garrafa 32-bit, .NET Framework 4.0, WineD3D e execucao direta do launcher `GunBound.exe`.

Instale o Flatpak e o Bottles:

```bash
sudo apt install flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.usebottles.bottles
```

Abra o Bottles uma vez e aguarde o download dos componentes iniciais:

```bash
flatpak run com.usebottles.bottles
```

Depois, dentro da pasta extraida do cliente, execute:

```bash
chmod +x JogarLinux.sh
./JogarLinux.sh
```

Na primeira execucao, o inicializador:

1. solicita um ID de 3 a 12 letras ou numeros;
2. libera no sandbox apenas a pasta do cliente;
3. cria uma garrafa 32-bit chamada `Gunbound`;
4. desativa DXVK/VKD3D e usa WineD3D, necessario para os graficos antigos;
5. abre o instalador do .NET Framework 4.0 incluido no cliente;
6. abre o launcher do Gunbound diretamente pelo WineD3D.

Nas execucoes seguintes basta executar `./JogarLinux.sh` novamente.

> `Servidor/LigarLinux.sh` e o inicializador do **servidor** e deve ser executado dentro do repositorio. `JogarLinux.sh` e o inicializador do **jogo/cliente** e vem dentro do ZIP baixado pelo site. Eles possuem funcoes diferentes.

Se a criacao automatica da garrafa nao funcionar, abra o Bottles, aguarde a configuracao inicial e crie manualmente uma garrafa do tipo **Jogos**, arquitetura **32-bit**, com o nome exato `Gunbound`. Depois execute o script novamente.

Se a imagem aparecer com cores, textos ou blocos corrompidos, confirme que iniciou com `./JogarLinux.sh`, e nao abrindo o DxWnd manualmente. O hook de DirectDraw dessa versao do DxWnd causa corrupcao grafica no Wine. O inicializador tambem desativa automaticamente **DXVK** e **VKD3D** na garrafa e restaura o WineD3D.

O DxWnd continua disponivel apenas para testes manuais:

```bash
./JogarLinux.sh --dxwnd
```

### Solucao de problemas no Linux

Se o terminal informar que `JogarLinux.sh` nao existe, confirme que voce extraiu o ZIP e entrou na pasta correta:

```bash
cd ~/Downloads/GunboundCliente
chmod +x JogarLinux.sh
./JogarLinux.sh
```

Se o Bottles nao estiver instalado ou configurado:

```bash
flatpak info com.usebottles.bottles
flatpak run com.usebottles.bottles
```

Se a garrafa ja existia com DXVK ativado, feche o jogo e aplique a configuracao usada pelo inicializador:

```bash
flatpak run --command=bottles-cli \
  com.usebottles.bottles edit \
  -b Gunbound \
  --params "dxvk:false,vkd3d:false"
```

Para testar diretamente o launcher, sem o hook grafico do DxWnd:

```bash
flatpak run --command=bottles-cli \
  com.usebottles.bottles run \
  -b Gunbound \
  -e "$HOME/Downloads/GunboundCliente/Arquivos/GunBound.exe"
```

Mensagens como `lsteamclient disabled`, `ntsync requested but unavailable` e fallback para `fsync` podem aparecer durante a criacao da garrafa e nao indicam, por si so, falha do jogo.

Depois de atualizar o repositorio ou o `JogarLinux.sh`, reinicie o servidor e baixe um novo `GunboundCliente.zip`, pois o site insere a versao atual do inicializador Linux no momento em que gera o download.

O Bottles Flatpak e a versao recomendada e testada pelo projeto Bottles e inclui as dependencias e ferramentas necessarias. Consulte a [documentacao de instalacao](https://docs.usebottles.com/getting-started/installation) e a pagina no [Flathub](https://flathub.org/apps/com.usebottles.bottles).

## macOS

No macOS, a opcao mais simples e o [CrossOver](https://www.codeweavers.com/crossover/download). Ele possui interface grafica, suporta Macs Intel e Apple Silicon e oferece um periodo gratuito para testar o jogo antes da compra.

Em Macs com Apple Silicon (M1, M2, M3 ou posteriores), instale tambem o Rosetta 2:

```bash
softwareupdate --install-rosetta --agree-to-license
```

No CrossOver:

1. escolha **Install an unlisted application**;
2. crie uma garrafa chamada `Gunbound`, preferencialmente do tipo **Windows 7 64-bit**;
3. na mesma garrafa, execute `Arquivos/Apps e Softwares/dotNetFx40_Full_x86_x64.exe`;
4. use **Run Command** para executar `Arquivos/dxwnd.exe`;
5. no DxWnd, de dois cliques em **GunBound**.

Se houver problemas graficos, use o renderizador **WineD3D** e desative inicialmente D3DMetal e DXVK nessa garrafa.

### Alternativa gratuita para macOS

O [Kegworks](https://github.com/thor/homebrew-kegworks) e gratuito, sucede o Wineskin e suporta macOS 10.15.4 ou posterior. Ele requer mais configuracao manual que o CrossOver:

```bash
brew install --cask --no-quarantine Kegworks-App/kegworks/kegworks
```

Crie um wrapper para o cliente, instale nele o .NET Framework 4.0 incluido e configure `Arquivos/dxwnd.exe` como executavel principal. Use WineD3D para o DirectX antigo. Por depender do DxWnd e de injecao entre processos, a compatibilidade pode variar conforme a versao do macOS.

# Comandos dentro do Gunbound
* help = Ver todos os comandos
* /jogar = Iniciar jogo forcado, mesmo sozinho
* /genero
  * m = masculino
  * f = feminino
* /mobile 0 a 18
  * 0 = Armor
  * 1 = Mage
  * 2 = Nak
  * 3 = Trico
  * 4 = Bigfoot
  * 5 = Boomer
  * 6 = Raon
  * 7 = Lightning
  * 8 = J.D
  * 9 = A.Sate
  * 10 = Ice
  * 11 = Turtle
  * 12 = Grub
  * 13 = Aduka
  * 17 = Dragon
  * 18 = Knight
* /guild NOMEDOCLA = Altera o nome do seu cla/guild
* /avatar = Gera e te veste com avatares aleatorios
* /msg #,*,$,%,^,&(mensagem) = Envia uma mensagem para todos.
* /conexao = Verifica se a conexao ainda esta ativa.
* /online = Verifica jogadores online agora.
* /salvar = Salva suas informacoes, por exemplo: avatares, guild...
* /fechar = Fechar sala atual
* /sair = Sair da sala atual
* /quit = Fechar jogo imediatamente

# Screenshot do Servidor
![Screenshot](https://i.imgur.com/6GnlzCY.png)

![Screenshot](https://i.imgur.com/9icVXXi.png)

![Screenshot](https://i.imgur.com/fQrzmzS.png)

# Screenshot do Cliente/Jogo
![Screenshot](https://i.imgur.com/U0LSqSZ.png)

![Screenshot](https://i.imgur.com/Zr2yWvp.png)

![Screenshot](https://i.imgur.com/Ql8XUUe.png)

![Screenshot](https://i.imgur.com/D3iWtGu.png)

![Screenshot](https://i.imgur.com/b15z0aU.png)

![Screenshot](https://i.imgur.com/QBtDTsf.png)

![Screenshot](https://i.imgur.com/dDkAbbX.png)

![Screenshot](https://i.imgur.com/6QCwkgd.png)

# Créditos
O script em Python do servidor foi retirado do repositorio https://github.com/jglim/gunbound-server feito por @jglim.

O que eu fiz? Corrigi alguns bugs, automatizei a aplicação para detectar seu ip sempre que ligar o servidor, juntei cliente/jogo com o servidor, criei o executavel/batch para deixar fácil a abertura do servidor mesmo em um prendrive.
