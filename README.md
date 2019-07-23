# Profilr

This is a very simple profiler for use in programmatic collection of data.

It returns JSON data to stdout for easy processing. Most of the information comes directly from
[`rusage`](http://www.fifi.org/cgi-bin/man2html/usr/share/man/man3/BSD::Resource.3pm.gz), but it
also includes "ClockTime". Clock time is the real runtime of the process, as measaured by profilr.
This is done on a "best effort" basis, and not guaranteed to be precise to the same degree that
`rusage` is.

Windows is not currently supported.

## Usage

### Build

`make build`

### Test

`make test`

### Install

Copy `bin/profilr` into your PATH.

### Run

After building:

`profilr echo run your command here`

More advanced options can be seen by running `profilr -help`.

Example:

```sh
> $ bin/profilr -count 5 -no-progress sleep 1
> {"Results":[{"ClockTime":1.005691523,"UserTimeNano":0,"SystemTimeNano":728000,"CPUTimeNano":0,"MaxRSS":4328,"IXRSS":0,"IDRSS":0,"ISRSS":0,"SoftPageFaults":61,"HardPageFaults":0,"Swaps":0,"InBlock":0,"OutBlock":0,"MsgSent":0,"MsgReceived":0,"SignalsReceived":0,"VoluntaryCtxSwitches":2,"InvoluntaryCtxSwitches":1},{"ClockTime":1.001391345,"UserTimeNano":1023000,"SystemTimeNano":0,"CPUTimeNano":0,"MaxRSS":4328,"IXRSS":0,"IDRSS":0,"ISRSS":0,"SoftPageFaults":62,"HardPageFaults":0,"Swaps":0,"InBlock":0,"OutBlock":0,"MsgSent":0,"MsgReceived":0,"SignalsReceived":0,"VoluntaryCtxSwitches":2,"InvoluntaryCtxSwitches":1},{"ClockTime":1.001830047,"UserTimeNano":0,"SystemTimeNano":1474000,"CPUTimeNano":0,"MaxRSS":4328,"IXRSS":0,"IDRSS":0,"ISRSS":0,"SoftPageFaults":62,"HardPageFaults":0,"Swaps":0,"InBlock":0,"OutBlock":0,"MsgSent":0,"MsgReceived":0,"SignalsReceived":0,"VoluntaryCtxSwitches":2,"InvoluntaryCtxSwitches":1},{"ClockTime":1.002343281,"UserTimeNano":686000,"SystemTimeNano":0,"CPUTimeNano":0,"MaxRSS":4756,"IXRSS":0,"IDRSS":0,"ISRSS":0,"SoftPageFaults":64,"HardPageFaults":0,"Swaps":0,"InBlock":0,"OutBlock":0,"MsgSent":0,"MsgReceived":0,"SignalsReceived":0,"VoluntaryCtxSwitches":2,"InvoluntaryCtxSwitches":1},{"ClockTime":1.001267403,"UserTimeNano":941000,"SystemTimeNano":0,"CPUTimeNano":0,"MaxRSS":4756,"IXRSS":0,"IDRSS":0,"ISRSS":0,"SoftPageFaults":62,"HardPageFaults":0,"Swaps":0,"InBlock":0,"OutBlock":0,"MsgSent":0,"MsgReceived":0,"SignalsReceived":0,"VoluntaryCtxSwitches":2,"InvoluntaryCtxSwitches":0}]}
```

* Ordinarily, there is a progress bar **unless stdout is a terminal**.
* `-no-progress` forcefully disables it.
* `-force-progress` will force the progress bar, even if stdout is not a terminal.
* `-count N` will run the command _N_ times and return the results for each one.
* `-workdir` will set the working directory of the command you give it.
* All above arguments must be set **before** the command. Ex: `profilr echo hello -count 5` will return 1 result, but `profilr -count 5 echo hello` will have 5 results.

### Docker Images

You can get the docker images for `profilr` from
[`ericmiller/profilr`](https://cloud.docker.com/repository/registry-1.docker.io/ericmiller/profilr).

You can also build them yourself using `make docker-images`.
