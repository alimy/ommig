// Copyright 2023 Michael Li <alimy@gility.net>. All rights reserved.
// Use of this source code is governed by Apache License 2.0 that
// can be found in the LICENSE file.

package main

import (
	"github.com/alimy/ommig/cmd"
)

func main() {
	// setup root cli command of application
	cmd.Setup(
		"ommig",              // command name
		"ommig help toolkit", // command short describe
		"ommig help tookit",  // command long describe
	)

	// execute start application
	cmd.Execute()
}
