# Profilr

This is a very simple profiler for use in programmatic collection of data.

It returns JSON data to stdout for easy processing. Most of the information comes directly from
[`rusage`](http://www.fifi.org/cgi-bin/man2html/usr/share/man/man3/BSD::Resource.3pm.gz), but it
also includes "ClockTime". Clock time is the real runtime of the process, as measaured by profilr.
This is done on a "best effort" basis, and not guaranteed to be precise to the same degree that
`rusage` is.

## Usage

### Build

`go build`

### Run

`profilr echo run your command here`

More advanced options can be seen by running `profilr -help`.
