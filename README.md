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

### Docker Images

You can get the docker images for `profilr` from [`ericmiller/profilr`](https://cloud.docker.com/repository/registry-1.docker.io/ericmiller/profilr).

You can also build them yourself using `make docker-images`.
