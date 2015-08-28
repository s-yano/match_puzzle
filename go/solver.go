package main

import (
	"fmt"
	"strings"
)

type Pos struct {
	x, y int32
	v    int8
}

type Board map[string]Pos

func (b Board) Set(x int32, y int32, v int8) {
	b[key(x, y)] = Pos{x, y, v}
}
func (b Board) GetPos(x int32, y int32) Pos {
	return b[key(x, y)]
}
func (b Board) Get(x int32, y int32) int8 {
	return b.GetPos(x, y).v
}
func (b Board) Del(x int32, y int32) {
	delete(b, key(x, y))
}
func (b Board) Dump() {
	for _, v := range b {
		fmt.Printf("%d,%d -> %d\n", v.x, v.y, v.v)
	}
}
func (b Board) PrintBoard() {
	p0, p1 := b.BoundaryBox()
	for y := p0.y; y <= p1.y; y++ {
		for x := p0.x; x <= p1.x; x++ {
			// fmt.Printf("%d", b.Get(x, y))
			switch b.Get(x, y) {
			case 0:
				fmt.Printf("  ")
			case 1:
				fmt.Printf("＼")
			case 2:
				fmt.Printf("／")
			}
		}
		fmt.Println()
	}
}
func (b Board) BoundaryBox() (Pos, Pos) {
	var xmin, xmax, ymin, ymax int32
	first := true
	for _, v := range b {
		if first {
			xmin, xmax, ymin, ymax = v.x, v.x, v.y, v.y
			first = false
		} else {
			if xmin > v.x {
				xmin = v.x
			}
			if xmax < v.x {
				xmax = v.x
			}
			if ymin > v.y {
				ymin = v.y
			}
			if ymax < v.y {
				ymax = v.y
			}
		}
	}
	return Pos{xmin, ymin, 0}, Pos{xmax, ymax, 0}
}
func (b Board) Rotate() Board {
	des := make(Board)
	for _, v := range b {
		new_v := v.v
		if v.v != 0 {
			new_v = 3 - v.v
		}
		des[key(-v.y, v.x)] = Pos{-v.y, v.x, new_v}
	}
	return des
}
func (b Board) Mirror() Board {
	des := make(Board)
	for _, v := range b {
		new_v := v.v
		if v.v != 0 {
			new_v = 3 - v.v
		}
		des[key(-v.x, v.y)] = Pos{-v.x, v.y, new_v}
	}
	return des
}
func (b Board) Serialize() string {
	p0, p1 := b.BoundaryBox()
	s := make([]string, (p1.x-p0.x+2)*(p1.y-p0.y+1))
	for y := p0.y; y <= p1.y; y++ {
		for x := p0.x; x <= p1.x; x++ {
			s = append(s, fmt.Sprintf("%d", b.Get(x, y)))
		}
		s = append(s, "/")
	}
	return strings.Join(s, "")
}

func key(x int32, y int32) string {
	return fmt.Sprintf("%d/%d", x, y)
}

func find(s []string, value string) bool {
	for _, v := range s {
		if v == value {
			return true
		}
	}
	return false
}

func (b Board) same(st []string) bool {
	a1 := b
	for i := 0; i < 4; i++ {
		a1 = a1.Rotate()
		if find(st, a1.Serialize()) {
			return true
		}
		a2 := a1.Mirror()
		if find(st, a2.Serialize()) {
			return true
		}
	}
	return false
}

var res []string
var count int32 = 0

func (b Board) sub(x int32, y int32, m int8, dep int32) {
	if dep == 5 {
		if b.same(res) {
			return
		}
		res = append(res, b.Serialize())
		count++
		// b.PrintBoard()
		// fmt.Println("----------", count)
		return
	}
	if b.Get(x, y) != 0 {
		return
	}
	b.Set(x, y, m)
	if m == 1 {
		b.sub(x-1, y-1, 1, dep+1)
		b.sub(x+1, y+1, 1, dep+1)
	} else if m == 2 {
		b.sub(x+1, y-1, 2, dep+1)
		b.sub(x-1, y+1, 2, dep+1)
	}
	b.sub(x-1, y, 3-m, dep+1)
	b.sub(x+1, y, 3-m, dep+1)
	b.sub(x, y-1, 3-m, dep+1)
	b.sub(x, y+1, 3-m, dep+1)
	b.Del(x, y)
}

func main() {
	b := make(Board)

	b.sub(0, 0, 1, 0)
	fmt.Println(count, "通り")
}
