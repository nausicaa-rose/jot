#lang scribble/manual
@require[@for-label[jot
                    racket/base]]

@title{jot}
@author{wtee}

@defmodule[jot]

A simple, minimal application for notetaking and record keeping on
the command line. Run @code{jot "Some quick note or other."} to add a
timestampped entry to your jottery, a plain text file.

By default, the location of your jottery is [Home Dir]/jottery.txt.
This can be changed by editing the path in [Home Dir]/.config/jot/location.txt.
