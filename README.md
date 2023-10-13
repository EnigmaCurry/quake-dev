# Quake Map Development Environment

This is a development environment for making
[Quake](https://bethesda.net/en/game/quake) maps with
[Trenchbroom](https://trenchbroom.github.io/) on Arch Linux. This
loosly follows the excellent guides from
[dumptruck_ds](https://www.youtube.com/playlist?list=PLgDKRPte5Y0AZ_K_PZbWbgBAEt5xf74aE)
and
[jonathanlinat/quake-leveldesign-starterkit](https://github.com/jonathanlinat/quake-leveldesign-starterkit),
both of which are unfortunately focused toward MS windows platform.

## Pre-requisites

 * [Arch Linux](https://archlinux.org/)
   * If you run MS Windows, use [jonathanlinat/quake-leveldesign-starterkit](https://github.com/jonathanlinat/quake-leveldesign-starterkit) instead.
 * A copy of Quake installed (tested with the Steam version). (You
   only really need the `id1` folder which you can copy from any
   install.)
 * Your user account requires `sudo` privileges to install all the
dependencies.
 * You must [enable the multilib repository](https://wiki.archlinux.org/title/Official_repositories#multilib).
 * You will also need to pre-install GNU make and git:

```
sudo pacman -S make git
```

## Setup

Clone the repository:

```
git clone https://github.com/EnigmaCurry/quake-dev ~/git/vendor/enigmacurry/quake-dev
cd ~/git/vendor/enigmacurry/quake-dev
```

## Run the Makefile

At the top of the [Makefile](Makefile) there are a number of
environment variables that have default values, but one of them may be
especially important if you didnt install the steam version:

 * `QUAKE_ROOT_ID1`

This variable must be set to the full path to the `id1` folder from
your Quake directory. The default value
(`${HOME}/.steam/steam/steamapps/common/Quake/rerelease/id1`) is the
correct path for the Steam version of the 2021 re-release of Quake. If
this is not correct for your system, you will need to modify the
variable, which you can do by editing the Makefile, or simply setting
the environment variable before you run it.

Install all the dependencies:

```
make deps
```

The game assets directory `id1` has now been copied to
`./ironwail/id1`, and the original quake directory is no longer
necessary.

## Trenchbroom tutorial

### Setup Trenchbroom

 * Open Trenchbroom
 * Select `New map`
 * Click `Open preferences...`
 * Find `Quake` in the preferences.
 * Set the Game Path to the full path to the created ironwail
   directory (eg.
   `/home/ryan/git/vendor/enigmacurry/quake-dev/ironwail`)
 * Click `Configure Engines...`
 * Click the `+` icon to add a new Profile.
 * Enter the profile name: `ironwail`
 * Enter the Path: `/usr/bin/ironwail`
 * Exit from the preferences menus you're done with setup.

### Modify an existing level

Lets start with making a small modification to the original Quake
start map. The map source is found in the `source` directory named
`start.map`.

 * Open Trenchbroom
 * Click `Browse` to open an existing .map file.
 * Navigate to the `source` directory and open `start.map`.
 * Choose `Quake` from the list of games.
 * Use the `Map Format` of `Autodetect` or `Standard`
 * Click OK.

Modify the level by adding some additional entities to the scene.

 * Move your view inside the level to where the character starts.
 * Click the `Entity` tab, and find the `monster_dog` entity.
 * Drag a few dogs into the main starting area.
 * Go to `File` -> `Save document as`, and save it as `start_dogs.map`.
 * You may close trenchbroom if you wish.

Build and run the modified map, run:

```
make map=start_dogs
```

The game should now start and you should see the dogs.

You can load any map name this same way, for example if you create a
new level with trenchbroom called `foo`, you can build and run it:

```
make map=foo
```

If you want to make it even easier, set the `map` variable ahead of
time:

```
## For example say you are working on the foo map for awhile now:
export map=foo

## Now you can just run make, and the foo level is loaded by default:
make

## But later on you can run any level just like before:
make map=e1m1
```

### Source files

The files in the `source` directory are copies of the original quake
levels ([open sourced by John Romero in
2016!](https://rome.ro/news/2016/2/14/quake-map-sources-released)).
These files can be very useful to examine for your own design ideas,
but you can also choose to delete if you don't need them.

You can load any level from inside the quake console:

 * From inside the game, hit the `~` key to open the console
 * type `map foo` to load the `foo` map.

## Links

 * [dumptruck_ds trenchbroom
   series](https://www.youtube.com/playlist?list=PLgDKRPte5Y0AZ_K_PZbWbgBAEt5xf74aE)
 * [Quake mapping tips video](https://yewtu.be/watch?v=G4tWWiuaF7g)
 * [quake command line arguments](https://quakewiki.org/wiki/Command_line_parameters) (these are the same with ironwail)
 * [Map_compiling](https://quakewiki.org/wiki/Map_compiling) (on quake-wiki)
 * [QodotPlugin/Qodot](https://github.com/QodotPlugin/Qodot/) - import your quake
   maps into the Godot game engine!
 * [jitspoe/godot_bsp_importer](https://github.com/jitspoe/godot_bsp_importer) -
   an alternative to Qodot that claims to have less overdraw by
   importing directly from bsp (?).
 * [Godot FPS quickstart](https://github.com/StayAtHomeDev-Git/FPS-Godot-Basic-Setup)
 * [BloodThief game using Qodot](https://yewtu.be/watch?v=DMJ7i4nuMVA)
 * [Interesting maps and dev-blog](https://shoresofnis.wordpress.com/maps/)
