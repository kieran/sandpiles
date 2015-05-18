// defining the file contents so that they can be imported elsewhere
package main

import (
	"fmt"
	"image"
	"image/color"
	"image/png"
	"os"
)

// Define the Sandpile structure
type Sandpile struct {
	Size    int
	Lattice [][]int
}

// Initialize a new Sandpile
func NewSandpile(size int) *Sandpile {
	sandpile := new(Sandpile)
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

// png the fucker
func PNGPile(sandpile *Sandpile, name string) {
	// start a new png
	f, err := os.Create(name)

	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	// start a new image
	m := image.NewNRGBA(image.Rectangle{Min: image.Point{0, 0}, Max: image.Point{sandpile.Size, sandpile.Size}})

	// write out the pile values
	for row := range sandpile.Lattice {
		for col := range sandpile.Lattice[row] {
			height := sandpile.Lattice[row][col]
			switch height {
			case 0:
				m.SetNRGBA(row, col, color.NRGBA{255, 255, 250, 213})
			case 1:
				m.SetNRGBA(row, col, color.NRGBA{189, 73, 50, 255})
			case 2:
				m.SetNRGBA(row, col, color.NRGBA{219, 158, 54, 255})
			case 3:
				m.SetNRGBA(row, col, color.NRGBA{99, 15, 35, 255})
			}
		}
	}

	if err = png.Encode(f, m); err != nil {
		fmt.Println(err)
		os.Exit(1)
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

	sandpile.Lattice[x][y] += 1
	if sandpile.Lattice[x][y] >= 4 {
		sandpile.Lattice[x][y] -= 4
		Drop(sandpile, x+1, y)
		Drop(sandpile, x-1, y)
		Drop(sandpile, x, y+1)
		Drop(sandpile, x, y-1)
	}
}

func main() {
	size := 4096
	iterations := 100000000

	sandpile := NewSandpile(size)

	for i := 0; i < iterations; i++ {
		Step(sandpile)

		if i%(iterations/10000) == 0 {
			fmt.Printf("\rOn %d/%d", i, iterations)
			name := fmt.Sprintf("%dx%d-after-%d-iterations.png", size, size, i)
			PNGPile(sandpile, name)
		}
	}

	// PrintPile(sandpile)

}
