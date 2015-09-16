# git-bash-tee

A sample app to demonstrate an issue with new git bash and tee [Windows]

Tested with

- 1.9.5.msysgit.0 -> works as expected
- 2.5.1.windows.1 -> fails hard, occasionally the execution just freezes during postinstall task
- 2.5.2.windows.2 -> fails hard

The minimal case when I can reproduce the issue:

  - Have a bash script which tries to pipe the output to a file with `tee`
  - Call `npm install` in the script
  - Call a gulp task in the script

Having a `postinstall` task in package.json leads to some additional issues. Slight variations depending on whether calling a gulp task (`gulp test`) or a node script (`node build.js`). On 2.5.1 the `postinstall` task freezes occasionally (reminds me of this https://github.com/git-for-windows/git/issues/227).

If commenting out `tee` from the end of the `install.sh`, things work as expected everywhere:

```
$ ./install.sh
Starting install...
==============
Running npm install...
npm WARN package.json git-bash-tee@0.0.0 No repository field.

> git-bash-tee@0.0.0 postinstall C:\data\harri\tiedostot\Projektit\Muut\temp\git-bash-tee
> node build.js

Hello from build.js
==============
Running gulp task...
[22:26:27] Using gulpfile C:\data\harri\tiedostot\Projektit\Muut\temp\git-bash-tee\gulpfile.js
[22:26:27] Starting 'test'...
Hello from gulp!
[22:26:27] Finished 'test' after 52 μs
==============
Installed!
```


Most often with 2.5.2:

- `postinstall` task leads to a failing assertion
- `EINVAL` when `tee` enabled
```
$ ./install.sh
Starting install...
==============
Running npm install...
npm WARN package.json git-bash-tee@0.0.0 No repository field.

> git-bash-tee@0.0.0 postinstall C:\data\harri\tiedostot\Projektit\Muut\temp\git
-bash-tee
> node build.js


Assertion failed: ((handle))->activecnt >= 0, file src\win\pipe.c, line 1430
==============
Running gulp task...
[22:24:19]
Error: write EINVAL
    at errnoException (net.js:904:11)
    at Socket._write (net.js:645:26)
    at doWrite (_stream_writable.js:226:10)
    at writeOrBuffer (_stream_writable.js:216:5)
    at Socket.Writable.write (_stream_writable.js:183:11)
    at Socket.write (net.js:615:40)
    at Object.module.exports [as log] (C:\Users\Harri\AppData\Roaming\npm\node_modules\gulp\node_modules\gulp-util\lib\log.js:6:18)
    at Liftoff.handleArguments (C:\Users\Harri\AppData\Roaming\npm\node_modules\gulp\bin\gulp.js:117:9)
    at Liftoff.<anonymous> (C:\Users\Harri\AppData\Roaming\npm\node_modules\gulp\node_modules\liftoff\index.js:192:16)
    at module.exports (C:\Users\Harri\AppData\Roaming\npm\node_modules\gulp\node_modules\liftoff\node_modules\flagged-respawn\index.js:17:3)
==============
Installed!
```
