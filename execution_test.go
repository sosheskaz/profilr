package main

import (
	"os/exec"
	"testing"
)

func TestProfileRun(t *testing.T) {
	cmd := exec.Command("echo", "hello, world")
	execution := Execution{Cmd: cmd}
	result, err := execution.ProfileRun()
	if err != nil {
		t.Fatal(err)
	}
	if result == nil {
		t.Fatal("Error: Returned nil")
	}
}
