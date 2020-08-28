package main

import (
	"flag"

	"github.com/uzudil/benji4000/core"
)

func main() {
	fullscreen := flag.Bool("fullscreen", false, "Run at fullscreen")
	nosound := flag.Bool("nosound", false, "Run without sound")

	var scale int
	flag.IntVar(&scale, "scale", 3, "Image scale factor")
	flag.Parse()

	showAst := false
	core.Run("bscript", scale, fullscreen, nosound, &showAst)
}
