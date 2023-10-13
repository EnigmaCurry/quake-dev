ERICW_TOOLS_VERSION ?= 2.0.0-alpha2
QUAKE_ROOT_ID1 ?= ${HOME}/.steam/steam/steamapps/common/Quake/rerelease/id1

game ?= id1
map ?= start
args ?= "+skill 3 +developer 1 -nosound"

.PHONY: run # Build and run the map
run: build
	ironwail -basedir ironwail  ${args} -game ${game} +map ${map}

.PHONY: build # Build the map
build:
	cd ironwail && ../tools/ericw-tools/bin/qbsp -basedir . ../games/${game}/maps/${map}.map ${game}/maps/${map}.bsp && ../tools/ericw-tools/bin/light ${game}/maps/${map}.bsp && ../tools/ericw-tools/bin/vis ${game}/maps/${map}.bsp

.PHONY: help # Show this help screen
help:
	@grep -h '^.PHONY: .* #' Makefile | sed 's/\.PHONY: \(.*\) # \(.*\)/make \1 \t- \2/' | expand -t20

install-ericw-tools:
	curl -C - -L -o downloads/ericw-tools-${ERICW_TOOLS_VERSION}-Linux.zip https://github.com/ericwa/ericw-tools/releases/download/${ERICW_TOOLS_VERSION}/ericw-tools-${ERICW_TOOLS_VERSION}-Linux.zip
	unzip downloads/ericw-tools-${ERICW_TOOLS_VERSION}-Linux.zip -d tools
	mv tools/ericw-tools-${ERICW_TOOLS_VERSION}-Linux tools/ericw-tools

install-texmex:
	curl -C - -L -o downloads/texmex.zip https://valvedev.info/tools/texmex/texmex.zip
	mkdir -p tools/texmex
	unzip downloads/texmex.zip -d tools/texmex

install-yay:
	sudo pacman -S --needed base-devel git
	rm -rf downloads/yay
	git clone https://aur.archlinux.org/yay.git downloads/yay
	cd downloads/yay && makepkg -si

install-virtualenv:
	virtualenv tools/python-env

install-map2curve:
	curl -C - -L -o downloads/map2curve.zip https://www.moddb.com/downloads/mirror/178422/127/b03299fd60fc0d5f8cb22f9ce888ca34/
	mkdir -p tools/map2curve
	unzip downloads/map2curve.zip -d tools/map2curve

.PHONY: install-games
install-games:
	curl -C - -L -o downloads/quake_map_sources.zip https://valvedev.info/tools/quake-map-sources-and-original-wads/quake_map_sources.zip
	mkdir -p games/id1/maps
	unzip downloads/quake_map_sources.zip -d games/id1/maps
	perl-rename 'y/A-Z/a-z/' games/id1/maps/*
	chmod u+w games/id1/maps/*

install-wads:
	curl -C - -L -o downloads/quake_old_wads.zip https://valvedev.info/tools/quake-map-sources-and-original-wads/quake_old_wads.zip
	mkdir -p wads
	unzip downloads/quake_old_wads.zip -d wads
	curl -C - -L -o wads/prototype_1_3.wad https://github.com/jonathanlinat/quake-leveldesign-starterkit/raw/master/wads/prototype_1_3.wad
	curl -C - -L -o wads/rogue.wad https://github.com/jonathanlinat/quake-leveldesign-starterkit/raw/master/wads/rogue.wad
	curl -C - -L -o wads/hipnotic.wad https://github.com/jonathanlinat/quake-leveldesign-starterkit/raw/master/wads/hipnotic.wad
	curl -C - -L -o wads/id1.wad https://github.com/jonathanlinat/quake-leveldesign-starterkit/raw/master/wads/id1.wad
	perl-rename 'y/A-Z/a-z/' wads/*

create-ironwail:
	mkdir -p ironwail
	cp -a ${QUAKE_ROOT_ID1} ironwail/id1
	mkdir -p ironwail/id1/maps
	ln -sf $(realpath wads) ironwail/gfx

.PHONY: install # Install dependencies
install:
	@which yay || ${MAKE} --no-print-directory yay
	@which virtualenv3 || yay -S python python-virtualenv
	@which wine || yay -S wine
	@which trenchbroom || yay -S trenchbroom-bin
	@which ironwail || yay -S ironwail
	@which perl-rename || yay -S perl-rename
	@mkdir -p downloads
	@mkdir -p tools
	@test -d tools/ericw-tools || ${MAKE} --no-print-directory install-ericw-tools
	@test -d tools/texmex || ${MAKE} --no-print-directory install-texmex
	@test -d tools/python-env || ${MAKE} --no-print-directory install-virtualenv
	@tools/python-env/bin/pip install quake-cli-tools
	@test -d wads || ${MAKE} --no-print-directory install-wads
	@test -d games/id1 || ${MAKE} --no-print-directory install-games
	@test -d ironwail || ${MAKE} --no-print-directory create-ironwail

clean:
	rm -f ironwail/${game}/maps/*
