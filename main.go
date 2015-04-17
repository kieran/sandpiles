package main

import (
	"fmt"
	"image"
	"image/png"
	"image/color"
	"os"
)

// Define the Sandpile structure
type Sandpile struct {
	Frame   int
	Size    int
	Lattice [][]int
}

// Initialize a new Sandpile
func NewSandpile(size int) *Sandpile {
	sandpile := new(Sandpile)
	sandpile.Frame = 0
	sandpile.Size = size
	BuildLattice(sandpile)
	return sandpile
}

// Build a lattice
func BuildLattice(sandpile *Sandpile) *Sandpile {
	// allocate the 2d array to Lattice
	sandpile.Lattice = make([][]int, sandpile.Size)
	// add columns
	for i := range sandpile.Lattice {
		sandpile.Lattice[i] = make([]int, sandpile.Size)
	}
	return sandpile
}

// print the fucker
func PrintPile(sandpile *Sandpile) {
	for row := range sandpile.Lattice {
		for col := range sandpile.Lattice[row] {
			fmt.Printf("%d ", sandpile.Lattice[row][col])
		}
		fmt.Printf("\n")
	}
}

func SavePile(sandpile *Sandpile) {

}

func Step(sandpile *Sandpile) {
	x := sandpile.Size / 2
	y := sandpile.Size / 2
	Drop(sandpile, x, y)
}

func Drop(sandpile *Sandpile, x int, y int) {
	if x < 0 || x > sandpile.Size-1 {
		return
	}

	if y < 0 || y > sandpile.Size-1 {
		return
	}

	sandpile.Lattice[x][y] = sandpile.Lattice[x][y] + 1
	if sandpile.Lattice[x][y] == 4 {
		sandpile.Lattice[x][y] = 0
		Drop(sandpile, x+1, y)
		Drop(sandpile, x-1, y)
		Drop(sandpile, x, y+1)
		Drop(sandpile, x, y-1)
	}
}

func main() {
	size := 512
	iterations := 500000

	sandpile := NewSandpile(size)

	for i := 0; i < iterations; i++ {
		Step(sandpile)

		if i%(iterations/100) == 0 {
			fmt.Printf("\rOn %d/%d", i, iterations)
		}
	}

	// PrintPile(sandpile)

	// start a new png
	f, err := os.Create("test.png")

	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	// start a new image
	m := image.NewNRGBA(image.Rectangle{Min: image.Point{0, 0}, Max: image.Point{512, 512}})

	// write out the pile values
	for x := 0; x < 512; x++ {
		for y := 0; y < 512; y++ {
			height := sandpile.Lattice[x][y]
			m.SetNRGBA(x, y, color.NRGBA{uint8(height * 60), uint8(0), uint8(0), 255})
		}
	}

	if err = png.Encode(f, m); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

}
