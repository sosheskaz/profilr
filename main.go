package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"os/exec"

	"github.com/cheggaaa/pb/v3"
	"github.com/mattn/go-isatty"
)

func main() {
	count := flag.Int("count", 1, "Number of times to run the given command")
	noProgress := flag.Bool("no-progress", false, "Disable the progress bar when run in interactive mode; mutually exclusive with -force-progress")
	forceProgress := flag.Bool("force-progress", false, "Force displaying the progress bar; mutually exclusive with -no-progress")
	workDir := flag.String("workdir", ".", "Working directory for the command")
	help := flag.Bool("help", false, "Display this help message")

	flag.Parse()
	command := flag.Args()

	if *help {
		flag.Usage()
		os.Exit(0)
	}

	if flag.NArg() < 1 {
		flag.Usage()
		fmt.Println("At least one positional argument is required to specify the command.")
		os.Exit(1)
	}

	if *noProgress && *forceProgress {
		flag.Usage()
		fmt.Println("Error: -no-progress is mutually exclusive with -force-progress.")
		os.Exit(1)
	}

	showProgress := (*forceProgress || isatty.IsTerminal(os.Stdout.Fd())) && !*noProgress

	executions := make([]*ExecResult, *count)

	var bar *pb.ProgressBar
	if showProgress {
		bar = pb.StartNew(*count)
	}

	for idx, _ := range executions {
		cmd := exec.Command(command[0], command[1:]...)
		cmd.Dir = *workDir
		execCommand := Execution{
			Cmd: cmd,
		}
		result, err := execCommand.ProfileRun()
		if err != nil {
			fmt.Println(err)
			os.Exit(-1)
		}
		executions[idx] = result

		if bar != nil {
			bar.Increment()
		}
	}

	executionSet := ExecResultSet{
		Results: executions,
	}

	if bar != nil {
		bar.Finish()
	}

	output, err := json.Marshal(executionSet)

	if err != nil {
		fmt.Println(fmt.Errorf("Error when serializing JSON: %+v", err))
		os.Exit(-2)
	}

	fmt.Println(string(output))
}
