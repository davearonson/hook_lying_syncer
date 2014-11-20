hook_lying_syncer
=================

This project presents a way for Ruby coders to keep method_missing and
respond_to_missing? in sync.

The whole idea of finding a way to do that automagically was originally
inspired by [Avdi Grimm](http://about.avdi.org/)'s [blog
post](http://devblog.avdi.org/2011/12/07/defining-method_missing-and-respond_to-at-the-same-time/)
about the need to sync them.  I came up with a quick and dirty hack, and a
still-hacky improvement that seems to have been mangled by a blog platform
change or some such.

Then at RubyConf 2014, [Betsy Haibel](http://betsyhaibel.com/) gave a talk on
metaprogramming, including the need.  That inspired me to take another whack at
it, this time using the different approach shown in this repo (essentially, a
decorator class).

I got some suggestions and other help from [Chris
Hoffman](https://github.com/yarmiganosca), mainly in figuring out that I
shouldn't do the in-block object access the way I was trying to!  :-)

Status
-----

I have barely begun to work on this repo, so it's still a bit rough, as a
project per se.  My plan is to turn it into a gem.
