# FPGA Snake Game (Verilog HDL)

![HDL](https://img.shields.io/badge/HDL-Verilog-1f6feb)
![FPGA](https://img.shields.io/badge/FPGA-Intel%20MAX%2010%20(10M50DAF484C7G)-0071C5?logo=intel&logoColor=white)
![Board](https://img.shields.io/badge/board-Terasic%20DE10--Lite-555)
![Toolchain](https://img.shields.io/badge/toolchain-Quartus%20Prime%2018.1-555)
![License](https://img.shields.io/badge/license-MIT-2ea44f)

A snake game on the Terasic DE10-Lite, written entirely in Verilog HDL.

<img src="docs/images/de10-lite.jpg" alt="Terasic DE10-Lite FPGA board (Intel MAX 10), top view" width="720">

<sub>Target board: Terasic DE10-Lite. Representative photo, not this project's setup (the yellow labels are the photographer's). Photo: [“DE10-Lite-20240112_160112”](https://www.flickr.com/photos/fotoopa_hs/53459607598) by Frans ([fotoopa](https://www.flickr.com/photos/fotoopa_hs)), licensed under [CC BY 2.0](https://creativecommons.org/licenses/by/2.0/); resized.</sub>

## Project Overview

This project is a hardware-level implementation of the classic **Snake Game** developed for the **Terasic DE10-Lite (MAX10 FPGA)** platform. The system is built entirely using **Verilog HDL**, demonstrating hardware-software co-design principles, digital logic optimization, and real-time peripheral interfacing.

The goal of this project is to demonstrate how a responsive game system can be implemented using low-level digital logic, focusing on **resource optimization** and **efficient memory management** without the use of a microprocessor or high-level software.

This project is intended for:

* Developers interested in Verilog HDL and FPGA development.
* Students studying digital logic design, FSMs, and hardware resource optimization.

---

## Gameplay Features

### Dynamic Difficulty

* **Speed Leveling**: The game clock frequency automatically increases as the player's score rises, providing a smooth difficulty curve.
* **Real-time Feedback**: Current speed level is displayed via the onboard LEDs.

### Win/Loss Conditions

* **Game Over**: Triggered if the snake collides with the screen boundaries or its own body.
* **Score Tracking**: Points are awarded for each food item consumed, displayed on the seven-segment displays.

### Core Mechanics

* **Pointer-based Movement**: Uses a circular buffer to update coordinates efficiently.
* **Pseudo-random Spawning**: Food locations are generated using a hardware LFSR.
* **FSM-controlled Logic**: Dedicated states for Idle, Play, Pause, and Death.

---

## Controls

### Matrix Keypad (4x4)

| Action | Key Direction |
| --- | --- |
| Move Up | 2 |
| Move Down | 8 |
| Move Left | 4 |
| Move Right | 6 |

### Onboard Switches (SW)

| Function | Switch |
| --- | --- |
| Reset Game | SW[0] |
| Pause Game | SW[1] |

---

## System Architecture

### Hardware Logic Design

* **Clock Divider**: Generates three sub-clocks from the 50MHz source: a scan clock for displays, a game logic clock, and a 1Hz clock for the timer.
* **Keypad Scanner**: Implements matrix scanning to translate physical key presses into directional signals.
* **LFSR (Linear Feedback Shift Register)**: A 16-bit pseudo-random number generator used for randomized food spawning.

### Display Drivers

* **16x8 Dot Matrix**: Utilizes high-frequency row scanning and persistence of vision to render the snake and food.
* **Seven-Segment Controller**: Converts score and time data into BCD (Binary Coded Decimal) for real-time display.

---

## Core Engine Design

### Efficient Snake Management

* **Circular Buffer**: Instead of shifting an entire array, the engine updates only the `head_ptr` and `tail_ptr`.
* **Complexity**: Reduces update complexity from $O(N)$ to $O(1)$, significantly lowering FPGA logic gate utilization.

### Collision Detection

* **Boundary Check**: Monitors X/Y coordinates against map limits.
* **Self-collision**: Checks if the new head position is already marked as "occupied" in the game map grid.

---

## Code Structure

```
FPGA-Game-Engine/
├── Snake_Game_Top.v      // All RTL, one module per concern (see below)
├── Snake_Game_Top.qpf    // Quartus project
├── Snake_Game_Top.qsf    // Device, source and pin assignments
└── de10_lite_pins.tcl    // DE10-Lite pin map as a standalone, commented script
```

Modules in `Snake_Game_Top.v`:

| Module | Role |
| --- | --- |
| `Snake_Game_Top` | Top-level module & signal routing |
| `Clock_Divider` | Clock generation & dynamic frequency scaling |
| `Keypad_Scanner` | Matrix keypad scanning logic |
| `Game_Engine` | FSM, snake logic, LFSR, and collision |
| `Dot_Matrix_Driver` | Visual rendering for the 16x8 matrix |
| `Seven_Seg_Controller` | BCD conversion for score and time |

---

## Build

Target device: **MAX 10 `10M50DAF484C7G`** (DE10-Lite), built with **Quartus Prime 18.1 Lite Edition**.

1. Open `Snake_Game_Top.qpf` in Quartus.
2. Run **Processing → Start Compilation**. Pin assignments are already in the `.qsf`; `de10_lite_pins.tcl` holds the same map if you need to re-apply it.
3. Program the board with `output_files/Snake_Game_Top.sof` via **Tools → Programmer** (USB-Blaster).

Build outputs (`db/`, `incremental_db/`, `output_files/`) are not tracked; a full compile regenerates them.

---

## Summary

This project demonstrates a **complete hardware system** built with **Verilog HDL**, including:

* Optimized memory management through pointers.
* Real-time hardware peripheral interfacing.
* Pseudo-random number generation in logic.
* Dynamic Difficulty Scaling (DDS) through clock manipulation.

It serves as a comprehensive reference for low-level digital system integration on MAX10 FPGAs.

---

## License

[MIT](LICENSE) © 2026 Adam Fan
