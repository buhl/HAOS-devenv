### Small setup for developing home assistant add-ons
This repository is modeled after the `VSCode` way of setting up a development environment but without the bloated `VSCode` dependency.
So now you are free to use your editor-of-choice.

### Getting started
  * Clone this repository and enter it.
  * Run `make build`
  * Run `make run WD=<path-to-your-addon>`
  * Run `start-hassio` # this target will never detach. `ctrl-c` will kill `hassio`
  * ???
  * PROFIT!!

  It can take some time to load. But once fully loaded Home assistant should be
  available on `localhost:8123`. If `8123` was taken `7123` will be tried. If that port is
  also taken `6123` will be tried all they way down to `1123`.
  This way you can also, easily, run multiple instances of this `devenv` if you need to.

### Honorable mentions of other `make` targets

  * `stop-devenv`
  * `shell`
  * `shell-supervisor`
  * `observe`
  * `clean`

### About
This is just something I hacked together in an afternoon to aid my add-on development.
Feel free to give it a spin. Hopefully it can help you too.
If you have fixes/ideas or anything else don't hesitate to open a issue/PR - they are
always welcome.
