# Two-Player Gomoku Game in MIPS Assembly

A command-line implementation of the traditional Gomoku (Five in a Row) game, developed entirely in MIPS32 Assembly.This project was created as part of the Computer Architecture Lab (CO2008) at Ho Chi Minh City University of Technology (HCMUT)

## Project Overview

This application replicates the strategic board game Gomoku on a standard 15x15 grid. Two players (represented by X and O) take turns entering coordinates to place their pieces, aiming to be the first to form an unbroken line of five stones horizontally, vertically, or diagonally

## Key Features

* Standard 15x15 Game Board: Utilizes a standard grid size for gameplay.
* Two-Player Local Multiplayer: Supports a competitive mode where players alternate turns.
* Win and Tie Detection: Automatically identifies winning conditions or a draw when the board is full.
* Input Validation: Includes mechanisms to check for incorrect formats, out-of-range coordinates (valid range 0-14), or occupied spots, providing warnings and requiring re-input.
* File Persistence: Automatically exports the final board state and the game result to a file named "result.txt" upon completion[: 84].

## Technical Details

* Language: MIPS32 Assembly.
* Simulator: Developed and tested using the MARS MIPS Simulator.
* Architecture Concepts Applied:
    * Arithmetic and data transfer instructions.
    * Conditional branching and jump logic for win-checking algorithms.
    * Procedural programming for modular code structure.
    * File I/O system calls for saving game results.

## How to Run

1. Download and install the MARS MIPS Simulator.
2. Clone this repository to your local machine.
3. Open the main assembly file (e.g., gomoku.asm) in MARS.
4. Assemble the code by selecting F3.
5. Execute the program by selecting F5.
6. Follow the prompts in the MARS Run I/O terminal to play.

## Gameplay Instructions

* Players are prompted to input coordinates in the format x,y (e.g., 4,5 for row 4, column 5).
* Coordinates must be within the range of 0 to 14.
* Player 1 is assigned X and Player 2 is assigned O.
