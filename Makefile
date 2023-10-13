ERICW_TOOLS_VERSION ?= 2.0.0-alpha2
QUAKE_ROOT_ID1 ?= ${HOME}/.steam/steam/steamapps/common/Quake/rerelease/id1
BUILD_MAP_NAME ?= out
QUAKE_ARGS ?= -nosound

map ?= start

.PHONY: run # Build and run the map
run: build
	ironwail -basedir ironwail +map ${BUILD_MAP_NAME} ${QUAKE_ARGS}

.PHONY: build # Build the map
build:
	cd ironwail && ../tools/ericw-tools/bin/qbsp -basedir . ../source/${map}.map id1/maps/${BUILD_MAP_NAME}.bsp && ../tools/ericw-tools/bin/light id1/maps/${BUILD_MAP_NAME}.bsp

.PHONY: help # Show this help screen
help:
	@grep -h '^.PHONY: .* #' Makefile | sed 's/\.PHONY: \(.*\) # \(.*\)/make \1 \t- \2/' | expand -t20

ericw-tools:
	curl -C - -L -o downloads/ericw-tools-${ERICW_TOOLS_VERSION}-Linux.zip https://github.com/ericwa/ericw-tools/releases/download/${ERICW_TOOLS_VERSION}/ericw-tools-${ERICW_TOOLS_VERSION}-Linux.zip
	unzip downloads/ericw-tools-${ERICW_TOOLS_VERSION}-Linux.zip -d tools
	mv tools/ericw-tools-${ERICW_TOOLS_VERSION}-Linux tools/ericw-tools

texmex:
	curl -C - -L -o downloads/texmex.zip https://valvedev.info/tools/texmex/texmex.zip
	mkdir -p tools/texmex
	unzip downloads/texmex.zip -d tools/texmex

yay:
	sudo pacman -S --needed base-devel git
	rm -rf downloads/yay
	git clone https://aur.archlinux.org/yay.git downloads/yay
	cd downloads/yay && makepkg -si

virtualenv:
	virtualenv tools/python-env

map2curve:
	curl -C - -L -o downloads/map2curve.zip https://www.moddb.com/downloads/mirror/178422/127/b03299fd60fc0d5f8cb22f9ce888ca34/
	mkdir -p tools/map2curve
	unzip downloads/map2curve.zip -d tools/map2curve

map_source:
	curl -C - -L -o downloads/quake_map_sources.zip https://valvedev.info/tools/quake-map-sources-and-original-wads/quake_map_sources.zip
	mkdir -p source
	unzip downloads/quake_map_sources.zip -d source
	perl-rename 'y/A-Z/a-z/' source/*
	ln -s $(realpath wads) ironwail/gfx
	ln -s $(realpath wads) source/gfx

map_wads:
	curl -C - -L -o downloads/quake_old_wads.zip https://valvedev.info/tools/quake-map-sources-and-original-wads/quake_old_wads.zip
	mkdir -p wads
	unzip downloads/quake_old_wads.zip -d wads
	perl-rename 'y/A-Z/a-z/' wads/*

ironwail:
	mkdir -p ironwail
	cp -a ${QUAKE_ROOT_ID1} ironwail/id1
	mkdir -p ironwail/id1/maps

.PHONY: deps # Install dependencies
deps:
	@which yay || ${MAKE} --no-print-directory yay
	@which virtualenv3 || yay -S python python-virtualenv
	@which wine || yay -S wine
	@which trenchbroom || yay -S trenchbroom-bin
	@which ironwail || yay -S ironwail
	@which perl-rename || yay -S perl-rename
	@mkdir -p downloads
	@mkdir -p tools
	@mkdir -p game
	@test -d tools/ericw-tools || ${MAKE} --no-print-directory ericw-tools
	@test -d tools/texmex || ${MAKE} --no-print-directory texmex
	@test -d tools/python-env || ${MAKE} --no-print-directory virtualenv
	@tools/python-env/bin/pip install quake-cli-tools
	${MAKE} --no-print-directory map_wads
	${MAKE} --no-print-directory map_source
	${MAKE} --no-print-directory ironwail