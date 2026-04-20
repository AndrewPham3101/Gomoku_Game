# Two-Player Gomoku Game in MIPS Assembly

[cite_start]A command-line implementation of the traditional Gomoku (Five in a Row) game, developed entirely in MIPS32 Assembly[cite: 18, 64]. [cite_start]This project was created as part of the Computer Architecture Lab (CO2008) at Ho Chi Minh City University of Technology (HCMUT)[cite: 3, 8].

## Project Overview

[cite_start]This application replicates the strategic board game Gomoku on a standard 15x15 grid[cite: 59, 64]. [cite_start]Two players (represented by X and O) take turns entering coordinates to place their pieces, aiming to be the first to form an unbroken line of five stones horizontally, vertically, or diagonally[cite: 59, 70, 79, 80].

## Key Features

* [cite_start]Standard 15x15 Game Board: Utilizes a standard grid size for gameplay[cite: 59, 64].
* [cite_start]Two-Player Local Multiplayer: Supports a competitive mode where players alternate turns[cite: 64, 73].
* [cite_start]Win and Tie Detection: Automatically identifies winning conditions or a draw when the board is full[cite: 80, 81].
* [cite_start]Input Validation: Includes mechanisms to check for incorrect formats, out-of-range coordinates (valid range 0-14), or occupied spots, providing warnings and requiring re-input[cite: 75, 76, 77].
* [cite_start]File Persistence: Automatically exports the final board state and the game result to a file named "result.txt" upon completion[cite: 84].

## Technical Details

* [cite_start]Language: MIPS32 Assembly[cite: 18, 87].
* [cite_start]Simulator: Developed and tested using the MARS MIPS Simulator[cite: 18].
* Architecture Concepts Applied:
    * [cite_start]Arithmetic and data transfer instructions[cite: 19].
    * [cite_start]Conditional branching and jump logic for win-checking algorithms[cite: 20].
    * [cite_start]Procedural programming for modular code structure[cite: 20].
    * [cite_start]File I/O system calls for saving game results[cite: 84].

## How to Run

1. Download and install the MARS MIPS Simulator.
2. Clone this repository to your local machine.
3. Open the main assembly file (e.g., gomoku.asm) in MARS.
4. Assemble the code by selecting F3.
5. Execute the program by selecting F5.
6. Follow the prompts in the MARS Run I/O terminal to play.

## Gameplay Instructions

* [cite_start]Players are prompted to input coordinates in the format x,y (e.g., 4,5 for row 4, column 5)[cite: 75, 76].
* [cite_start]Coordinates must be within the range of 0 to 14[cite: 76].
* [cite_start]Player 1 is assigned X and Player 2 is assigned O[cite: 79].

## Academic Context

* [cite_start]Course: Computer Architecture Lab (CO2008)[cite: 3].
* [cite_start]Institution: Ho Chi Minh City University of Technology (HCMUT)[cite: 1, 8].
* [cite_start]Academic Year: 2024 - 2025[cite: 11].

---
[cite_start]Note: This project was developed as a formal academic assignment following specific curriculum requirements[cite: 4, 11].
