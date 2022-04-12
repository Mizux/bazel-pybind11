PROJECT := bazel-pybind11
BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
SHA1 := $(shell git rev-parse --verify HEAD)

# General commands
.PHONY: help
BOLD:=\e[1m
RESET:=\e[0m

help:
	@echo -e "${BOLD}SYNOPSIS${RESET}"
	@echo -e "\tmake <target> [NOCACHE=1]"
	@echo
	@echo -e "${BOLD}DESCRIPTION${RESET}"
	@echo -e "\ttest build inside docker container to have a reproductible build."
	@echo
	@echo -e "${BOLD}MAKE TARGETS${RESET}"
	@echo -e "\t${BOLD}help${RESET}: display this help and exit."
	@echo
	@echo -e "\t${BOLD}<platform>_<stage>${RESET}: build <stage> docker images for ALL DISTROS."
	@echo -e "\t${BOLD}<target>${RESET}: build the docker image for a specific <target> (platform,distro,stage)."
	@echo -e "\t${BOLD}save_<target>${RESET}: Save the <target> docker images."
	@echo -e "\t${BOLD}sh_<target>${RESET}: run a container using the <target> docker image (debug purpose)."
	@echo -e "\t${BOLD}clean_<target>${RESET}: Clean the docker image specified."
	@echo
	@echo -e "\t${BOLD}<target>${RESET}:"
	@echo -e "\t\t${BOLD}<platform>_<distro>_<stage>${RESET}"
	@echo
	@echo -e "\t${BOLD}<platform>${RESET}:"
	@echo -e "\t\t${BOLD}amd64${RESET}"
	@echo -e "\t\t${BOLD}arm64${RESET}"
	@echo -e "\t\t${BOLD}riscv64 (RISC-V 64bits, experimental)${RESET}"
	@echo
	@echo -e "\t${BOLD}<distro>${RESET}:"
	@echo -e "\t\t${BOLD}alpine${RESET} (edge)"
	@echo -e "\t\t${BOLD}archlinux${RESET} (latest)"
	@echo -e "\t\t${BOLD}centos${RESET} (latest)"
	@echo -e "\t\t${BOLD}debian${RESET} (latest)"
	@echo -e "\t\t${BOLD}fedora${RESET} (latest)"
	@echo -e "\t\t${BOLD}opensuse${RESET} (tumbleweed)"
	@echo -e "\t\t${BOLD}ubuntu${RESET} (rolling)"
	@echo
	@echo -e "\t${BOLD}<stage>${RESET}:"
	@echo -e "\t\t${BOLD}env${RESET}"
	@echo -e "\t\t${BOLD}devel${RESET}"
	@echo -e "\t\t${BOLD}build${RESET}"
	@echo -e "\t\t${BOLD}test${RESET}"
	@echo
	@echo -e "\te.g. 'make amd64_ubuntu_test'"
	@echo
	@echo -e "\t${BOLD}clean${RESET}: Remove cache and ALL docker images."
	@echo -e "\t${BOLD}clean_<distro>${RESET}: Remove cache and docker images for the specified distro."
	@echo -e "\t${BOLD}distclean${RESET}: Clean all docker images and remove all archives."
	@echo
	@echo -e "\t${BOLD}NOCACHE=1${RESET}: use 'docker build --no-cache' when building container (default use cache)."
	@echo
	@echo -e "branch: $(BRANCH)"
	@echo -e "sha1: $(SHA1)"

# Need to add cmd_distro to PHONY otherwise target are ignored since they do not
# contain recipe (using FORCE do not work here)
.PHONY: all
all: amd64

# Delete all implicit rules to speed up makefile
MAKEFLAGS += --no-builtin-rules
.SUFFIXES:
# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES :=
# Keep all intermediate files
# ToDo: try to remove it later
.SECONDARY:

# Docker image name prefix.
IMAGE := ${PROJECT}

ifdef NOCACHE
DOCKER_BUILD_CMD := docker build --no-cache
DOCKER_BUILDX_CMD := docker buildx build --no-cache
else
DOCKER_BUILD_CMD := docker build
DOCKER_BUILDX_CMD := docker buildx build
endif
DOCKER_RUN_CMD := docker run --rm --init --net=host

# Currently supported platform
PLATFORMS := amd64 arm64 riscv64
# Currently supported distro
DISTROS := alpine archlinux centos debian fedora opensuse ubuntu
# List of stages
STAGES := env devel build test

# $* stem
# $< first prerequist
# $@ target name

define build_stage =
#$$(info build_stage: PLATFORM:'$1' DISTRO:'$2' STAGE:'$3')

.PHONY: $1_$2_$3
$1_$2_$3: docker/$2/Dockerfile
	#@docker image rm -f ${IMAGE}:$$@ 2>/dev/null
	${DOCKER_BUILDX_CMD} --platform linux/$1 \
 --tag ${IMAGE}:$$@ \
 --target=$3 \
 -f $$< \
 ..

.PHONY: save_$1_$2_$3
save_$1_$2_$3: cache/$1/$2/docker_$3.tar
cache/$1/$2/docker_$3.tar: $1_$2_$3
	@rm -f $$@
	mkdir -p cache/$1/$2
	docker save ${IMAGE}:$$< -o $$@

.PHONY: sh_$1_$2_$3
sh_$1_$2_$3: $1_$2_$3
	${DOCKER_RUN_CMD} \
 -it \
 --name ortools_$$< \
 ${IMAGE}:$$<

.PHONY: clean_$1_$2_$3
clean_$1_$2_$3:
	docker image rm -f ${IMAGE}:$1_$2_$3 2>/dev/null
	rm -f cache/$1/$2/docker_$3.tar
endef

define build_distro =
#$$(info build_distro: PLATFORM:'$1' DISTRO:'$2')

$$(foreach stage,${STAGES},$$(eval $$(call build_stage,$1,$2,$${stage})))
endef

define build_platform =
#$$(info build_platform: PLATFORM:'$1')

$$(foreach distro,${DISTROS},$$(eval $$(call build_distro,$1,$${distro})))
endef

$(foreach platform,${PLATFORMS},$(eval $(call build_platform,${platform})))

## MERGE ##
define merge_stage =
#$$(info merge_stage: PLATFORM:'$1' STAGE:'$2')

.PHONY: $1_$2
$1_$2: $(addprefix $1_, $(addsuffix _$2, ${DISTROS}))

.PHONY: clean_$1_$2
clean_$1_$2: $(addprefix clean_$1_, $(addsuffix _$2, ${DISTROS}))
endef

define merge_platform =
#$$(info merge_platform: PLATFORM:'$1')

$$(foreach stage,${STAGES},$$(eval $$(call merge_stage,$1,$${stage})))

.PHONY: $1
$1: $1_test

.PHONY: clean_$1
clean_$1: $(addprefix clean_$1_, ${STAGES})
endef

$(foreach platform,${PLATFORMS},$(eval $(call merge_platform,${platform})))

## CLEAN ##
.PHONY: clean
clean: $(addprefix clean_, ${PLATFORMS})
	docker container prune -f
	docker image prune -f
	-rm -rf cache

.PHONY: distclean
distclean: clean
	-docker container rm -f $$(docker container ls -aq)
	-docker image rm -f $$(docker image ls -aq)
