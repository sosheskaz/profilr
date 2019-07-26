package main

import (
	"fmt"
	"os/exec"
	"syscall"
	"time"
)

type ExecResult struct {
	ClockTime              float64
	UserTimeNano           int
	SystemTimeNano         int
	CPUTimeNano            int
	MaxRSS                 int
	IXRSS                  int
	IDRSS                  int
	ISRSS                  int
	SoftPageFaults         int
	HardPageFaults         int
	Swaps                  int
	InBlock                int
	OutBlock               int
	MsgSent                int
	MsgReceived            int
	SignalsReceived        int
	VoluntaryCtxSwitches   int
	InvoluntaryCtxSwitches int
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
		UserTimeNano:           int(usage.Utime.Nano()),
		SystemTimeNano:         int(usage.Stime.Nano()),
		MaxRSS:                 int(usage.Maxrss),
		IXRSS:                  int(usage.Ixrss),
		IDRSS:                  int(usage.Idrss),
		ISRSS:                  int(usage.Isrss),
		SoftPageFaults:         int(usage.Minflt),
		HardPageFaults:         int(usage.Majflt),
		Swaps:                  int(usage.Nswap),
		InBlock:                int(usage.Inblock),
		OutBlock:               int(usage.Oublock),
		MsgSent:                int(usage.Msgsnd),
		MsgReceived:            int(usage.Msgrcv),
		SignalsReceived:        int(usage.Nsignals),
		VoluntaryCtxSwitches:   int(usage.Nvcsw),
		InvoluntaryCtxSwitches: int(usage.Nivcsw),
	}

	return result, nil
}
