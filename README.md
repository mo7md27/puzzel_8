🧩 8 Puzzle Game – Flutter + AI (DFS Solver)
🎯 Project Objective
To build an interactive 8-puzzle game where users can:

- Shuffle the tiles to create a new challenge
- Manually solve the puzzle
- Let the AI solve the puzzle using DFS (Depth-First Search)
🧠 Features
- 🌀 Randomized puzzle shuffling
- 🧮 Solving mechanism using Depth-First Search
- 🕹️ Interactive tile movement
- 🎯 Goal: Arrange tiles from 1 to 8, leaving the bottom-right tile empty
- 🚫 Detects and prevents unsolvable configurations (optional)
🚀 Getting Started
Requirements
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio or VS Code
- Emulator or physical device
Installation
1. Clone the repo:
git clone https://github.com/your-username/puzzel_8.git
cd puzzel_8
2. Install dependencies:
flutter pub get
3. Run the app:
flutter run
📂 Project Structure
lib/
├── models/
│   └── puzzle_state.dart       # Puzzle board state model
├── services/
│   └── dfs_solver.dart         # Depth-First Search logic
├── views/
│   └── home_screen.dart        # Game UI screen
├── widgets/
│   └── tile_widget.dart        # UI widget for puzzle tile
└── main.dart                   # App entry point
📸 Screenshots
You can insert screenshots or GIFs here of the gameplay and AI solver in action.
📌 Future Improvements
- [ ] Add more solving algorithms (e.g., A*, BFS)
- [ ] Add solving animation
- [ ] Count steps and display solving time
- [ ] Detect unsolvable states automatically
📄 License
This project is licensed under the MIT License. See the LICENSE file for more information.

Developed with 💡 and 🧠 using Flutter and AI
