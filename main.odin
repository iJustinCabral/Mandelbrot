package main

import rl "vendor:raylib"
import "core:math"
import "core:fmt"

WINDOW_WIDTH  :: 800
WINDOW_HEIGHT :: 600
MAX_ITERATION :: 100

main :: proc() {
    rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Mandelbrot Set")
    defer rl.CloseWindow()

    rl.SetTargetFPS(60)

    // Initial zoom and offset
    zoom: f64 = 1.0
    offset_x: f64 = -0.5
    offset_y: f64 = 0.0

    for !rl.WindowShouldClose() {
        // Handle zooming
        if rl.IsMouseButtonPressed(.LEFT) {
            mouse_pos := rl.GetMousePosition()
            target_x := f64(mouse_pos.x) / f64(WINDOW_WIDTH) * 4.0 - 2.0
            target_y := f64(mouse_pos.y) / f64(WINDOW_HEIGHT) * 4.0 - 2.0
            offset_x = target_x
            offset_y = target_y
        }
        
        zoom += f64(rl.GetMouseWheelMove()) * 0.1
        zoom = max(0.1, zoom) // Prevent zooming out too far

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        // Generate Mandelbrot set
        for y in 0..<WINDOW_HEIGHT {
            for x in 0..<WINDOW_WIDTH {
                // Convert screen coordinates to complex plane
                real := (f64(x) / f64(WINDOW_WIDTH) * 4.0 - 2.0) * zoom + offset_x
                imag := (f64(y) / f64(WINDOW_HEIGHT) * 4.0 - 2.0) * zoom + offset_y

                iteration := mandelbrot(real, imag)
                
                // Color based on iteration count
                if iteration == MAX_ITERATION {
                    rl.DrawPixel(i32(x), i32(y), rl.BLACK)
                } else {
                    color := get_color(iteration)
                    rl.DrawPixel(i32(x), i32(y), color)
                }
            }
        }

        // Draw simple instructions
        rl.DrawText("Left Click: Recenter | Mouse Wheel: Zoom", 10, 10, 20, rl.WHITE)
        rl.EndDrawing()
    }
}

mandelbrot :: proc(real, imag: f64) -> int {
    c := complex(real, imag)
    z := complex(0, 0)
    
    for i in 0..<MAX_ITERATION {
        z = z * z + c
        if abs(z) > 2.0 {
            return i
        }
    }
    return MAX_ITERATION
}

get_color :: proc(iteration: int) -> rl.Color {
    t := f32(iteration) / f32(MAX_ITERATION)
    r := u8(9 * (1-t) * t * t * t * 255)
    g := u8(15 * (1-t) * (1-t) * t * t * 255)
    b := u8(8.5 * (1-t) * (1-t) * (1-t) * t * 255)
    return rl.Color{r, g, b, 255}
}

abs :: proc(z: complex128) -> f64 {
    return math.sqrt(real(z)*real(z) + imag(z)*imag(z))
}
