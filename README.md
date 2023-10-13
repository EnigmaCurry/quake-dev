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
make install
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
start map. The map source is found in the `src` directory named
`start.map`.

 * Open Trenchbroom
 * Click `Browse` to open an existing .map file.
 * Navigate to the `quake1` directory and open `start.map`.
 * Choose `Quake` from the list of games.
 * Use the `Map Format` of `Autodetect` or `Standard`
 * Click OK.

Modify the level by adding some additional entities to the scene.

 * Move your view inside the level to where the character starts.
 * Click the `Entity` tab, and find the `monster_dog` entity.
 * Drag a few dogs into the main starting area.
 * Go to `File` -> `Save document as`, and save it as `start_dogs.map`
   inside the `src` directory (not in `quake1`).
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

### Build from Trenchbroom

As an alternative to running the `make` command on the command line,
you can build and run directly from trenchbroom.

 * Launch Trenchbroom
 * Click on `Run` -> `Compile Map...`
 * Create a new profile, or modify the existing Profile, rename it
   `build`.
 * Set the working directory as your main `quake-dev` directory. (eg.
   `~/git/vendor/enigmacurry/quake-dev`)
 * Click the `+` button under the `Details` panel, to create a new
   Task. Select `Run Tool`.
 * Set the Tool Path to `/usr/bin/make`
 * Set the Parameters to `build`
 * You can append whatever other arguments you need as parameters
   here.

The `Build` profile will only compile your map bsp, but will not
launch the game. You may create a second profile to build and run the
game:

 * Create a second profile just like above, and call it `Run`.
 * This time set the Parameters to `run`.

The `Run` target will build *and* launch the game when its finished.

### Source files

The files in the `src` directory are for your own maps that you make
or modify.

The files in the `quake1` directory are copies of the original quake
levels ([open sourced by John Romero in
2016!](https://rome.ro/news/2016/2/14/quake-map-sources-released)).
These files can be very useful to examine for your own design ideas.

Maps from either of these directories can be edited and played (eg.
`make map=e1m1` loads e1m1.map from the quake1 directory). The `src`
directory takes precedence over the `quake1` directory, so I recommend
you treat the `quake1` directory as read-only, and if you wish to edit
one of the original levels, copy it to the `src` directory first, with
the same name, and it will override the original level.

### Quake console

Here are a few useful commands you can use from the [quake
console](https://www.quakewiki.net/console/console-commands/quake-console-commands/).
Many of these you must enter each time you load the level, because
they are cleared on level exit, and you can't set operators like "god"
mode from autoexec.cfg.

 * From inside the game, hit the `~` key to open the console
 * Type `map foo` and press Enter to load the `foo` map.
 * Type `god` to turn on temporary god mode (cleared on level exit!).
 * Type `notarget` to turn of player targeting (unless you try to
   fight them! again, this is cleared on level exit.)
 * Type `noclip` to be able to fly, this is useful especially because
   you can fly outside of the level and see everything from an
   overview. Use the swimming controls `E` and `C` key to ascend and
   descend, but I like to re-map descend to be `Q` like it is in
   Godot.

## Links

 * [dumptruck_ds trenchbroom
   series](https://www.youtube.com/playlist?list=PLgDKRPte5Y0AZ_K_PZbWbgBAEt5xf74aE)
 * [Quake mapping tips video](https://yewtu.be/watch?v=G4tWWiuaF7g)
 * [Quake command line arguments](https://quakewiki.org/wiki/Command_line_parameters) (these are the same with ironwail)
 * [Quake console commands](https://www.quakewiki.net/console/console-commands/quake-console-commands/)
 * [Map_compiling](https://quakewiki.org/wiki/Map_compiling)
 * [QodotPlugin/Qodot](https://github.com/QodotPlugin/Qodot/) - import your quake
   maps into the Godot game engine!
 * [jitspoe/godot_bsp_importer](https://github.com/jitspoe/godot_bsp_importer) -
   an alternative to Qodot that claims to have less overdraw by
   importing directly from bsp (?).
 * [Godot FPS quickstart](https://github.com/StayAtHomeDev-Git/FPS-Godot-Basic-Setup)
 * [BloodThief game using Qodot](https://yewtu.be/watch?v=DMJ7i4nuMVA)
 * [Interesting maps and dev-blog](https://shoresofnis.wordpress.com/maps/)
