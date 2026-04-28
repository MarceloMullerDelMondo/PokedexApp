Sistema de Gerenciamento Pokedex (Dart/Flutter)
Este projeto foi desenvolvido como parte das atividades práticas de Sistemas de Informação. O objetivo é aplicar conceitos de programação funcional em Dart e desenvolvimento mobile com Flutter, criando uma interface dinâmica para visualização e gerenciamento de dados de Pokémons.  

Tecnologias Utilizadas

Dart: Linguagem base para toda a lógica de negócio e manipulação de coleções.  


Flutter: Framework para criação da interface de usuário multiplataforma.  


PokeAPI: Consumo de assets e sprites oficiais para exibição dos personagens.  


Programação Funcional: Uso intensivo de métodos como .where(), .map() e .reduce() para processamento de dados.  

📱 Funcionalidades do Projeto
O sistema é focado na experiência de um treinador gerenciando sua equipe, com as seguintes capacidades:


Listagem Dinâmica (HomeScreen): Exibição de uma lista de Pokémons utilizando ListView.builder, extraindo dados de objetos da classe Pokemon.  


Detalhes e Status (PokemonScreen): Tela detalhada que recebe dados via construtor, exibindo nome, nível, tipos e sprites.  

Sistema de Batalha Simulado:

Gerenciamento de HP e XP com feedback visual dinâmico.  

Lógica de Level-up automática ao atingir 100 de XP.  

Uso de setState para atualizações de interface em tempo real.  


Navegação com Retorno: Implementação de Navigator.pop para devolver o nível atualizado do Pokémon da tela de detalhes para a lista principal.  

📂 Estrutura do Projeto
Plaintext
ProjetoPokemon/
├── lib/
│   ├── main.dart           # Ponto de entrada e configuração do MaterialApp
│   ├── pokemon.dart        # Modelo de dados (Classe Pokemon)
│   ├── home_screen.dart    # Tela principal com a lista de Pokémons
│   └── pokemon_screen.dart # Tela de detalhes e lógica de status
└── pubspec.yaml            # Gerenciamento de dependências e assets
🚀 Como Executar o Projeto
Pré-requisitos:

Flutter SDK instalado.

Emulador Android/iOS ou navegador configurado.

Passos:

Clone o repositório:

Bash
git clone https://github.com/seu-usuario/ProjetoPokemon.git
Acesse a pasta do projeto:

Bash
cd ProjetoPokemon
Instale as dependências:

Bash
flutter pub get
Execute o app:

Bash
flutter run
