package main

import (
	"fmt"
	"os/exec"
	"syscall"
	"time"
)

type ExecResult struct {
	ClockTime              float64
	UserTimeNano           int64
	SystemTimeNano         int64
	CPUTimeNano            int64
	MaxRSS                 int64
	IXRSS                  int64
	IDRSS                  int64
	ISRSS                  int64
	SoftPageFaults         int64
	HardPageFaults         int64
	Swaps                  int64
	InBlock                int64
	OutBlock               int64
	MsgSent                int64
	MsgReceived            int64
	SignalsReceived        int64
	VoluntaryCtxSwitches   int64
	InvoluntaryCtxSwitches int64
}

type ExecResultSet struct {
	Results []*ExecResult
}

type Execution struct {
	Cmd *exec.Cmd
}

func (ex *Execution) ProfileRun() (*ExecResult, error) {
	cmd := ex.Cmd

	start := time.Now()
	err := cmd.Run()
	if err != nil {
		return nil, fmt.Errorf("Received Error while running command: %+v", err)
	}
	end := time.Now()

	delta := end.Sub(start).Seconds()

	usage := cmd.ProcessState.SysUsage().(*syscall.Rusage)

	result := &ExecResult{
		ClockTime:              delta,
		UserTimeNano:           usage.Utime.Nano(),
		SystemTimeNano:         usage.Stime.Nano(),
		MaxRSS:                 usage.Maxrss,
		IXRSS:                  usage.Ixrss,
		IDRSS:                  usage.Idrss,
		ISRSS:                  usage.Isrss,
		SoftPageFaults:         usage.Minflt,
		HardPageFaults:         usage.Majflt,
		Swaps:                  usage.Nswap,
		InBlock:                usage.Inblock,
		OutBlock:               usage.Oublock,
		MsgSent:                usage.Msgsnd,
		MsgReceived:            usage.Msgrcv,
		SignalsReceived:        usage.Nsignals,
		VoluntaryCtxSwitches:   usage.Nvcsw,
		InvoluntaryCtxSwitches: usage.Nivcsw,
	}

	return result, nil
}
