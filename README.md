# Kdwatch

Autoreloading display of [kramdown-rfc][] document in browser

[kramdown-rfc]: http://rfc.space

## Installation

```
$ pip3 install --upgrade xml2rfc
$ gem update
$ gem install kdwatch
```

* For some reason, the initial `gem install` takes a couple of minutes,
  during the first few of which it may seem nothing happens.
* If the above `pip3` doesn't work: in a pinch, kdrfc will use the IETF
  web service for xml2rfc processing (but that may be a bit slower).
* Depending on system configuration, add `sudo` (but don't if it isn't
  actually needed).

## Usage

* Open a separate terminal window/screen.
* Go to a directory that has a single draft-*.md (or select one by
  specifying the markdown file name on the command line) and run:

```
$ kdwatch
```

After about 10 seconds, a browser will open (or an error message will
pop up with the URL to use, which depends on the options given, but
defaults to <http://127.0.0.1:7991/>).

Now, whenever you do an editor save of the markdown file, after a
couple of seconds (1.6 s for my Intel Mac, 0.8 s for my M1 Mac) you
see an updated HTML in the browser.

You will need to keep the `kdwatch` terminal/screen open to see
potential error messages, e.g., if you break the markdown in some way.

### There can only be one (per host/port)

There can only be one kdwatch active on each host and port.  You will
need to specify a different port (or host!) to start more than one
pkdwatch.

* `-o host` to select an address on the serving host (default: 127.0.0.1)
* `-i` as a shortcut for `-o ::`
* `-p port` to select a port number (default: 7991)
* `-1` to `6` as a shortcut for `-p 7991` to `-p 7996` (must be last
  option because of an idiosyncrasy of the optionparser library)

kdwatch has two flags to simplify handling servers that might be
accumulating on one host/port:

* `-e` to kill (SIGINT) any current holder of the port given and exit
* `-r` to do this, and to start a new instance

So the most likely use is going to be:

```
kdwatch -r
```

or, if your drafts are weirdly named or you need to select one out of
many

```
kdwatch -r weird-draft.md
```

### This is a web server

The fun thing with the `-i` option is that you can replace the local
URL by filling in the hostname of the laptop and use the resulting URL
on a different browser (e.g., `http://mylaptop.local:7991` on your iPad or
another laptop), and save some screen real-estate on your laptop.

kdwatch essentially is a web server and, unless used on 127.0.0.1 (or
::1), is accessible to anyone who can access your laptop over IP.

That may be a security problem -- do not specify non-local hosts
unless you are not “on the Internet” (or trust the way I cobble
together software).
If you did, maybe `kdwatch -e` before going there!

The web-server function may also be a feature -- it even can be used for joint viewing...

### 7991, haven't I heard that number before?

The default port number was chosen after [RFC 7991], the initial (no
longer really authoritative) version of the v3 RFCXML specification,
and the port shortcuts 1 to 6 point to further RFCs from this series.
(7997 is a particularly lame RFC, so it cannot be chosen by a
shortcut [actually: this port is already registered for something else].)

[RFC 7991]: https://rfc-editor.org/rfc/rfc7991.html

## Feedback, please

This has only been tested on macOS and briefly on Linux.  No idea about WSL.
There is very little error handling yet, so restarts of the tool may
be required, or sometimes reloading in the browser (CMD-R/F5) is all
that is needed.

If you try it, please send feedback (and, in case of an error, *all*
output on the kdwatch terminal window, please).

Bug reports, pull requests, or simple suggestions are welcome on GitHub at
<https://github.com/cabo/kdwatch>, e.g., simply [submit an
issue][issues] or send me [mail][].

[issues]: https://github.com/cabo/kdwatch/issues
[mail]: mailto:cabo@tzi.org?Subject=kdwatch

## License

The gem is available as open source under the terms of the [MIT License][].

[MIT License]: https://opensource.org/licenses/MIT
