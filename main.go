package main

import "fmt"

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
	size := 500
	iterations := 1000000

	sandpile := NewSandpile(size)

	for i := 0; i < iterations; i++ {
		Step(sandpile)

		if i%1000 == 0 {
			fmt.Printf("%d/%d \n", i, iterations)
		}
	}

	PrintPile(sandpile)
}
