# container-exception-logger
A tool designed to run inside of a container which is able to get its input
outside of the container.

This tool was created because there was not possible to get any information
outside of a container. The tool is mainly used by interpreter's default hooks
to pass unhandled exceptions to a host for further analysis.

## Format specification
It's possible to use whatever format of a message you want.
Openshift logging system (fluentd) and ABRT use
JSON. For this reason, we recommend using JSON too.

### Mandatory elements
Tools which parse container-exception-logger messages expecting the messages
contain following elements:
 * `type`: string - exception type - Python, Python3, Ruby, etc.
 * `executable`: string - executable which caused the problem
 * `reason`: string - reason of the problem
 * `backtrace`: string - backtrace of the problem
 * `time`: int - seconds since 1970-01-01 00:00:00 UTC

### Optional elements
Additional elements can be added without any limitation. For instance `pid`,
`uid`, `msg`, etc.

Example of a message:
```
{"type": "Python3", "executable": "/usr/bin/will_python3_raise", "reason": "will_python3_raise:3:<module>:ZeroDivisionError: division by zero", "backtrace": "will_python3_raise:3:<module>:ZeroDivisionError: division by zero\n\nTraceback (most recent call last):\n  File \"/usr/bin/will_python3_raise\", line 3, in <module>\n 0/0\nZeroDivisionError: division by zero\n\nLocal variables in innermost frame:\n__name__: '__main__'\n__doc__: None\n__package__: None\n__loader__: <_frozen_importlib_external.SourceFileLoader object at 0x7fc4568a9780>\n__spec__: None\n__annotations__: {}\n__builtins__: <module 'builtins' (built-in)>\n__file__: '/usr/bin/will_python3_raise'\n__cached__: None\n", "time": 1521454815, "pid": 23}
```

## How to use container-exception-logger
**container-exception-logger** - log from a container to a host

Usage: `container-exception-logger [--no-tag | --tag TAG | --help]`

**Parameters:**

`--no-tag` - do not tag a message in logs

`--tag` - change tag of a message in logs (defaults: 'container-exception-logger')

**Example of usage:**

For better illustration variable MSG contains a message from previous capture 'Format specification'.
```
Container:
 $ echo $MSG | container-exception-logger
Host's log:
 Mar 19 14:59:04 localhost.localdomain dockerd-current[981]: container-exception-logger - $MSG

Container:
 $ echo $MSG | container-exception-logger --no-tag
Host's log:
 Mar 19 15:00:27 localhost.localdomain dockerd-current[981]: $MSG

Container:
 $ echo $MSG | container-exception-logger --tag new-tag
Host's log:
 Mar 19 15:00:27 localhost.localdomain dockerd-current[981]: new-tag - $MSG
```
