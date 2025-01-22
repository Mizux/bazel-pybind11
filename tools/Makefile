PROJECT := pb11
BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
SHA1 := $(shell git rev-parse --verify HEAD)

# General commands
.PHONY: help
BOLD=\e[1m
RESET=\e[0m

help:
	@echo -e "${BOLD}SYNOPSIS${RESET}"
	@echo -e "\tmake <TARGET> [NOCACHE=1]"
	@echo
	@echo -e "${BOLD}DESCRIPTION${RESET}"
	@echo -e "\tTools to generate various wheel packages."
	@echo
	@echo -e "${BOLD}MAIN TARGETS${RESET}"
	@echo -e "\t${BOLD}help${RESET}: display this help and exit."
	@echo -e "\t${BOLD}python${RESET}: Build musllinux and manylinux python '${PROJECT}' wheel packages (3.8+)."
	@echo -e "\t${BOLD}python_<platform>${RESET}: Build all python '${PROJECT}' wheel packages (3.8+) for a specific platform."
	@echo -e "\t${BOLD}python_<platform>_<step>${RESET}: Build all python '${PROJECT}' wheel packages (3.8+) for a specific platform."
	@echo -e "\t${BOLD}python_<target>_<step>${RESET}: Build python '${PROJECT}' wheel packages (3.8+) for a specific target."
	@echo -e "\t${BOLD}save_python_<target>${RESET}: Save python '${PROJECT}' image."
	@echo -e "\t${BOLD}clean_python_<target>${RESET}: Clean manylinux and musllinux python '${PROJECT}' wheel packages."
	@echo -e "\t${BOLD}sh_python_<target>${RESET}: Run a container using the python '${PROJECT}' image."
	@echo
	@echo -e "\t${BOLD}<platform>${RESET}:"
	@echo -e "\t\t${BOLD}amd64${RESET}"
	@echo -e "\t\t${BOLD}arm64${RESET}"
	@echo
	@echo -e "\t${BOLD}<target>${RESET}:"
	@echo -e "\t\t${BOLD}<platform>_<distro>${RESET}"
	@echo -e "\t\t${BOLD}<platform>_manylinux_cp<version>${RESET}"
	@echo
	@echo -e "\t${BOLD}<distro>${RESET}:"
	@echo -e "\t\t${BOLD}manylinux${RESET} (manylinux_2_28)"
	@echo -e "\t\t${BOLD}musllinux${RESET} (musllinux_1_2)"
	@echo
	@echo -e "\t${BOLD}<version>${RESET}:"
	@echo -e "\t\t${BOLD}39${RESET} Python3.9"
	@echo -e "\t\t${BOLD}310${RESET} Python3.10"
	@echo -e "\t\t${BOLD}311${RESET} Python3.11"
	@echo -e "\t\t${BOLD}312${RESET} Python3.12"
	@echo -e "\t\t${BOLD}313${RESET} Python3.13"
	@echo
	@echo -e "\t${BOLD}<step>${RESET}:"
	@echo -e "\t\t${BOLD}env${RESET}"
	@echo -e "\t\t${BOLD}devel${RESET}"
	@echo -e "\t\t${BOLD}build${RESET}"
	@echo -e "\t\t${BOLD}test${RESET}"
	@echo -e "\t\t${BOLD}export${RESET}"
	@echo -e "\te.g. 'make python_amd64_manylinux_cp39_export'"
	@echo -e "\te.g. 'make python_arm64_musllinux_export'"
	@echo
	@echo -e "\t${BOLD}NOCACHE=1${RESET}: use 'docker build --no-cache' when building container (default use cache)."
	@echo -e "\t${BOLD}VERBOSE=1${RESET}: use 'docker build --progress=plain' when building container."
	@echo
	@echo -e "${BOLD}NOTES${RESET}"
	@echo -e "\tAll generated code will be located in the export/ folder, use target ${BOLD}distclean${RESET} to remove it."
	@echo

# Need to add cmd_distro to PHONY otherwise target are ignored since they do not
# contain recipe (using FORCE do not work here)
.PHONY: all
all: python

# Delete all implicit rules to speed up makefile
.SUFFIXES:
# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES :=
# keep all intermediate files e.g. export/docker_*.tar
# src: https://www.gnu.org/software/make/manual/html_node/Special-Targets.html
.SECONDARY:

$(info branch: ${BRANCH})
$(info SHA1: ${SHA1})

DOCKER_BUILD_CMD := docker build
DOCKER_BUILDX_CMD := docker buildx build
ifdef NOCACHE
DOCKER_BUILD_CMD := ${DOCKER_BUILD_CMD} --no-cache
DOCKER_BUILDX_CMD := ${DOCKER_BUILDX_CMD} --no-cache
endif
ifdef VERBOSE
DOCKER_BUILD_CMD := ${DOCKER_BUILD_CMD} --progress=plain
DOCKER_BUILDX_CMD := ${DOCKER_BUILDX_CMD} --progress=plain
endif
DOCKER_RUN_CMD := docker run --rm --init --net=host

###############
###  PYTHON  ##
###############
# $* stem
# $< first prerequist
# $@ target name
PYTHON_PLATFORMS := amd64 arm64
PYTHON_DISTROS := manylinux musllinux
PYTHON_STAGES := env devel build test

export:
	-mkdir $@

cache:
	-mkdir $@

## MANYLINUX ##
PYTHON_VERSIONS := 39 310 311 312 313

export/manylinux: | export
	-mkdir -p $@

export/manylinux/build-manylinux.sh: build-manylinux.sh | export/manylinux
	cp $< $@

define manylinux_inner =
#$$(info manylinux_inner: PLATFORM:'$1' VERSION:'$2' STAGE:'$3')

.PHONY: python_$1_manylinux_cp$2_$3
python_$1_manylinux_cp$2_$3: $1/manylinux.Dockerfile export/manylinux/build-manylinux.sh
	@docker image rm -f ${PROJECT}:$$@ 2>/dev/null
	${DOCKER_BUILDX_CMD} --platform linux/$1 \
 --tag ${PROJECT}:$$@ \
 --build-arg GIT_BRANCH=${BRANCH} \
 --build-arg GIT_SHA1=${SHA1} \
 --build-arg PYTHON_VERSION=$2 \
 --target=$3 \
 -f $$< \
 export/manylinux

.PHONY: save_python_$1_manylinux_cp$2_$3
save_python_$1_manylinux_cp$2_$3: cache/docker_$1_manylinux_cp$2_$3.tar
cache/docker_$1_manylinux_cp$2_$3.tar: python_$1_manylinux_cp$2_$3 | cache
	@rm -f $$@
	docker save ${PROJECT}:$$< -o $$@

.PHONY: clean_python_$1_manylinux_cp$2_$3
clean_python_$1_manylinux_cp$2_$3: $1/manylinux.Dockerfile export/manylinux/build-manylinux.sh
	docker image rm -f ${PROJECT}:python_$1_manylinux_cp$2_$3 2>/dev/null
	rm -f cache/docker_$1_manylinux_cp$2_$3.tar

# Debug purpose
.PHONY: sh_python_$1_manylinux_cp$2_$3
sh_python_$1_manylinux_cp$2_$3: python_$1_manylinux_cp$2_$3
	${DOCKER_RUN_CMD} \
 -v `pwd`/export:/export \
 -it \
 --name ${PROJECT}_$$< \
 ${PROJECT}:$$<
endef

define manylinux_outer =
#$$(info manylinux_outer: PLATFORM: '$1' VERSION: '$2')

$$(foreach stage,${PYTHON_STAGES},$$(eval $$(call manylinux_inner,$1,$2,$${stage})))

.PHONY: python_$1_manylinux_cp$2_export
python_$1_manylinux_cp$2_export: python_$1_manylinux_cp$2_build
	${DOCKER_RUN_CMD} \
 -v `pwd`/export:/export \
 -it \
 --name ${PROJECT}_$$< \
 ${PROJECT}:$$< \
 "cp build*/python/dist/*-many*.whl /export"
endef

$(foreach version,${PYTHON_VERSIONS},$(eval $(call manylinux_outer,amd64,${version})))
$(foreach version,${PYTHON_VERSIONS},$(eval $(call manylinux_outer,arm64,${version})))

# Merge
define manylinux_merge =
#$$(info manylinux_merge: PLATFORM:'$1' STAGE:'$2')

.PHONY: python_$1_manylinux_$2
python_$1_manylinux_$2: $(addprefix python_$1_manylinux_cp, $(addsuffix _$2, ${PYTHON_VERSIONS}))
.PHONY: save_python_$1_manylinux_$2
save_python_$1_manylinux_$2: $(addprefix save_python_$1_manylinux_cp, $(addsuffix _$2, ${PYTHON_VERSIONS}))
.PHONY: clean_python_$1_manylinux_$2
clean_python_$1_manylinux_$2: $(addprefix clean_python_$1_manylinux_cp, $(addsuffix _$2, ${PYTHON_VERSIONS}))
endef

$(foreach stage,${PYTHON_STAGES} export,$(eval $(call manylinux_merge,amd64,${stage})))
$(foreach stage,${PYTHON_STAGES} export,$(eval $(call manylinux_merge,arm64,${stage})))

## MUSLLINUX ##
export/musllinux: | export
	-mkdir -p $@

export/musllinux/build-musllinux.sh: build-musllinux.sh | export/musllinux
	cp $< $@

define musllinux_inner =
#$$(info musllinux_inner: PLATFORM:'$1' VERSION:'$2' STAGE:'$3')

.PHONY: python_$1_musllinux_cp$2_$3
python_$1_musllinux_cp$2_$3: $1/musllinux.Dockerfile | export/musllinux/build-musllinux.sh
	@docker image rm -f ${PROJECT}:$$@ 2>/dev/null
	${DOCKER_BUILDX_CMD} --platform linux/$1 \
 --tag ${PROJECT}:$$@ \
 --build-arg GIT_BRANCH=${BRANCH} \
 --build-arg GIT_SHA1=${SHA1} \
 --build-arg PYTHON_VERSION=$2 \
 --target=$3 \
 -f $$< \
 export/musllinux

.PHONY: save_python_$1_musllinux_cp$2_$3
save_python_$1_musllinux_cp$2_$3: cache/docker_$1_musllinux_cp$2_$3.tar
cache/docker_$1_musllinux_cp$2_$3.tar: python_$1_musllinux_cp$2_$3 | cache
	@rm -f $$@
	docker save ${PROJECT}:$$< -o $$@

.PHONY: clean_python_$1_musllinux_cp$2_$3
clean_python_$1_musllinux_cp$2_$3: $1/musllinux.Dockerfile | export/musllinux/build-musllinux.sh
	docker image rm -f ${PROJECT}:python_$1_musllinux_cp$2_$3 2>/dev/null
	rm -f cache/docker_$1_musllinux_cp$2_$3.tar

# Debug purpose
.PHONY: sh_python_$1_musllinux_cp$2_$3
sh_python_$1_musllinux_cp$2_$3: python_$1_musllinux_cp$2_$3
	${DOCKER_RUN_CMD} \
 -v `pwd`/export:/export \
 -it \
 --name ${PROJECT}_$$< \
 ${PROJECT}:$$<
endef

define musllinux_outer =
#$$(info musllinux_outer: PLATFORM: '$1' VERSION: '$2')

$$(foreach stage,${PYTHON_STAGES},$$(eval $$(call musllinux_inner,$1,$2,$${stage})))

.PHONY: python_$1_musllinux_cp$2_export
python_$1_musllinux_cp$2_export: python_$1_musllinux_cp$2_build
	${DOCKER_RUN_CMD} \
 -v `pwd`/export:/export \
 -it \
 --name ${PROJECT}_$$< \
 ${PROJECT}:$$< \
 "cp build*/python/dist/*-musl*.whl /export"
endef

$(foreach version,${PYTHON_VERSIONS},$(eval $(call musllinux_outer,amd64,${version})))
$(foreach version,${PYTHON_VERSIONS},$(eval $(call musllinux_outer,arm64,${version})))

# Merge
define musllinux_merge =
#$$(info musllinux_merge: PLATFORM:'$1' STAGE:'$2')

.PHONY: python_$1_musllinux_$2
python_$1_musllinux_$2: $(addprefix python_$1_musllinux_cp, $(addsuffix _$2, ${PYTHON_VERSIONS}))
.PHONY: save_python_$1_musllinux_$2
save_python_$1_musllinux_$2: $(addprefix save_python_$1_musllinux_cp, $(addsuffix _$2, ${PYTHON_VERSIONS}))
.PHONY: clean_python_$1_musllinux_$2
clean_python_$1_musllinux_$2: $(addprefix clean_python_$1_musllinux_cp, $(addsuffix _$2, ${PYTHON_VERSIONS}))
endef

$(foreach stage,${PYTHON_STAGES} export,$(eval $(call musllinux_merge,amd64,${stage})))
$(foreach stage,${PYTHON_STAGES} export,$(eval $(call musllinux_merge,arm64,${stage})))

## MERGE DISTRO ##
define python_distro_merge =
#$$(info python_distro_merge: PLATFORM:'$1' STAGE:'$2')

.PHONY: python_$1_$2
python_$1_$2: $(addprefix python_$1_, $(addsuffix _$2, ${PYTHON_DISTROS}))
.PHONY: save_python_$1_$2
save_python_$1_$2: $(addprefix save_python_$1_, $(addsuffix _$2, ${PYTHON_DISTROS}))
.PHONY: clean_python_$1_$2
clean_python_$1_$2: $(addprefix clean_python_$1_, $(addsuffix _$2, ${PYTHON_DISTROS}))
endef

$(foreach stage,${PYTHON_STAGES} export,$(eval $(call python_distro_merge,amd64,${stage})))
$(foreach stage,${PYTHON_STAGES} export,$(eval $(call python_distro_merge,arm64,${stage})))

## MERGE PLATFORM ##
define clean_python_platform =
#$$(info clean_python_platform: PLATFORM:'$1')

.PHONY: clean_python_$1
clean_python_$1: $(addprefix clean_python_$1_, ${PYTHON_STAGES})
endef

$(foreach platform,${PYTHON_PLATFORMS},$(eval $(call clean_python_platform,${platform})))


define python_platform_merge =
#$$(info python_platform_merge: STAGE:'$1')

.PHONY: python_$1
python_$1: $(addprefix python_, $(addsuffix _$1, ${PYTHON_PLATFORMS}))
.PHONY: save_python_$1
save_python_$1: $(addprefix save_python_, $(addsuffix _$1, ${PYTHON_PLATFORMS}))
.PHONY: clean_python_$1
clean_python_$1: $(addprefix clean_python_, $(addsuffix _$1, ${PYTHON_PLATFORMS}))
endef

$(foreach stage,${PYTHON_STAGES} export,$(eval $(call python_platform_merge,${stage})))

# Alias
.PHONY: python
python: python_amd64_export

.PHONY: clean_python
clean_python: $(addprefix clean_python_, ${PYTHON_PLATFORMS})
	-rm -rf cache/*
	-rm -rf export/*

#############
##  CLEAN  ##
#############
.PHONY: clean
clean: clean_python
	-docker container prune -f
	-docker image prune -f
	-rm -rf cache

.PHONY: distclean
distclean: clean
	-docker container ls -a
	-docker container prune -f
	-docker image ls -a
	-docker image prune -a -f
	-docker system df
	-docker system prune -a -f
	-rm -rf export
