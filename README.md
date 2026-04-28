---

## Sistema de Gerenciamento Pokedex (Dart/Flutter)

Este projeto foi desenvolvido como parte das atividades práticas de **Sistemas de Informação**[cite: 1, 2]. [cite_start]O objetivo é aplicar conceitos de programação funcional em **Dart** e desenvolvimento mobile com **Flutter**, criando uma interface dinâmica para visualização e gerenciamento de dados de Pokémons[cite: 1, 2].

### Tecnologias Utilizadas

* **Dart**: Linguagem base para toda a lógica de negócio e manipulação de coleções[cite: 1, 2].
* **Flutter**: Framework para criação da interface de usuário multiplataforma[cite: 1, 2].
* **PokeAPI**: Consumo de assets e sprites oficiais para exibição dos personagens[cite: 1, 2].
* **Programação Funcional**: Uso intensivo de métodos como `.where()`, `.map()` e `.reduce()` para processamento de dados[cite: 1, 2].

### 📱 Funcionalidades do Projeto

O sistema é focado na experiência de um treinador gerenciando sua equipe, com as seguintes capacidades:

* **Listagem Dinâmica (HomeScreen)**: Exibição de uma lista de Pokémons utilizando `ListView.builder`, extraindo dados de objetos da classe `Pokemon`[cite: 1, 2].
* **Detalhes e Status (PokemonScreen)**: Tela detalhada que recebe dados via construtor, exibindo nome, nível, tipos e sprites[cite: 1, 2].
* **Sistema de Batalha Simulado**:
    * Gerenciamento de **HP** e **XP** com feedback visual dinâmico[cite: 1, 2].
    * Lógica de **Level-up** automática ao atingir 100 de XP[cite: 1, 2].
    * Uso de `setState` para atualizações de interface em tempo real[cite: 1, 2].
* **Navegação com Retorno**: Implementação de `Navigator.pop` para devolver o nível atualizado do Pokémon da tela de detalhes para a lista principal[cite: 1, 2].

### 📂 Estrutura do Projeto

```text
ProjetoPokemon/
├── lib/
│   ├── main.dart           # Ponto de entrada e configuração do MaterialApp
│   ├── pokemon.dart        # Modelo de dados (Classe Pokemon)
│   ├── home_screen.dart    # Tela principal com a lista de Pokémons
│   └── pokemon_screen.dart # Tela de detalhes e lógica de status
└── pubspec.yaml            # Gerenciamento de dependências e assets
```

### 🚀 Como Executar o Projeto

**Pré-requisitos:**
* Flutter SDK instalado.
* Emulador Android/iOS ou navegador configurado.

**Passos:**
1. Clone o repositório:
   ```bash
   git clone https://github.com/seu-usuario/ProjetoPokemon.git
   ```
2. Acesse a pasta do projeto:
   ```bash
   cd ProjetoPokemon
   ```
3. Instale as dependências:
   ```bash
   flutter pub get
   ```
4. Execute o app:
   ```bash
   flutter run
   ```
