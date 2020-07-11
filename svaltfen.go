package main

import (
	"flag"
	"os"

	"github.com/uzudil/benji4000/bscript"
	"github.com/uzudil/benji4000/gfx"
	"github.com/uzudil/benji4000/sound"
)

func repl(video *gfx.Gfx, sound *sound.Sound) {
	bscript.Repl(video, sound)
}

func main() {
	showAst := flag.Bool("ast", false, "print AST and not execute?")
	fullscreen := flag.Bool("fullscreen", false, "Run at fullscreen")

	var scale int
	flag.IntVar(&scale, "scale", 2, "Image scale factor")

	flag.Parse()

	video := gfx.NewGfx(scale, *fullscreen)
	sound := sound.NewSound()

	go func() {
		bscript.Run("bscript", showAst, nil, video, sound)
		os.Exit(0)
	}()

	video.Render.MainLoop()
}
