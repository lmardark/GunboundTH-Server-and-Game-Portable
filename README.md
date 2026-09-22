# Servidor de Gunbound Thor Hammer com o Jogo incluso. 
Servidor de Gunbound Thor Hammer já pronto para ligar e jogar com seus amigos, o jogo/cliente do Gunbound está incluso!

* Ao ligar o servidor, você irá ver o IP local do seu servidor no terminal, você deve acessar o IP do servidor no navegador para baixar o jogo/cliente para entrar no Gunbound.
* Eu automatizei tudo, a criação de contas é feita na primeira vez que você logar no Gunbound, ou seja, nunca vai dar erro de conta inexistente ou login incorreto.
* Digite /help dentro do jogo para saber todos os comandos disponiveis no servidor.

# Como ligar o servidor

## Windows
Dê dois cliques em `Servidor/Ligar.bat`. Ele instala o Python e o WinRAR sozinho se precisar.

## Linux / Mac
Instale antes: `python3`, `php` e `7z` (pacote `p7zip-full` no Linux, `brew install p7zip php` no Mac). Depois:
```
cd Servidor
./LigarLinux.sh
```
O script extrai o cliente, sobe o site de download (com fallback automático pra porta 8080 se a 80 estiver ocupada) e liga o servidor do jogo.

**Atenção:** o cliente do Gunbound é um executável de Windows (jogo de 2004). Em Linux/Mac, os jogadores precisam do [Wine](https://www.winehq.org/) para rodá-lo — o servidor em si funciona nativo, mas o jogo não tem versão para Linux/Mac.

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
