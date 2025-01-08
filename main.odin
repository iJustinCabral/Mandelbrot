package main

import "core:fmt"
import rl "vendor:raylib"

WINDOW_SIZE :: 1000
ITERATIONS  :: 100

main :: proc() {
    rl.InitWindow(WINDOW_SIZE, WINDOW_SIZE, "Mandlebrot Visualizer")
    defer rl.CloseWindow()

    for !rl.WindowShouldClose() {
	// Updates

	// Drawing
	rl.BeginDrawing()
	defer rl.EndDrawing()
    }
}


