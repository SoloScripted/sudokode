# Sudokode

An AI-powered Sudoku game built with Flutter and Dart. Challenge yourself with generated puzzles and get a little help when you're stuck.

## Features

-   **Responsive UI**: Adapts to different screen sizes for a great experience on web and mobile.
-   **Dynamic Puzzle Generation**: Every new game provides a unique, solvable Sudoku puzzle.
-   **Conflict Highlighting**: Automatically highlights numbers that conflict in a row, column, or 3x3 box.
-   **Difficulty Levels**: Choose from Easy, Medium, Hard, or Expert to match your skill level.
-   **Interactive Number Pad**: Shows how many of each number are left to be placed.
-   **Hint System**: Get up to 5 hints per game to help you when you're stuck.
-   **Game Timer**: Tracks completion time.
-   **Game Controls**: Easily start a new game or reset the current board.
-   **Localization**: Supports multiple languages.

## Development

This project uses a `Makefile` to simplify common development tasks.

### Getting Started

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/SoloScripted/sudokode.git
    cd sudokode
    ```
2.  **Setup the project:**
    This command will fetch all dependencies and generate localization files.
    ```bash
    make setup
    ```
3.  **Run the app:**
    ```bash
    make run
    ```

### Available Commands

Here are some of the most common commands. For a full list, run `make help`.

| Command        | Description                                  |
| :------------- | :------------------------------------------- |
| `make setup`      | Sets up the project for the first time.      |
| `make get`        | Fetches project dependencies.                |
| `make run`        | Runs the app in debug mode.                  |
| `make install`    | Installs the app on a connected device.      |
| `make build-web`  | Creates a release build for the web.         |
| `make build-apk`  | Builds the Android APK.                      |
| `make build-aab`  | Builds the Android App Bundle for release.   |
| `make icons`      | Generates launcher icons.                    |
| `make analyze`    | Analyzes the Dart source code for issues.    |
| `make format`     | Formats all Dart files in the project.       |
| `make clean`      | Removes all build artifacts.                 |
| `make help`       | Displays a list of all available commands.   |

## Future Enhancements
-   Save and load game state.
-   Enhanced animations and sound effects.
-   User statistics and leaderboards.