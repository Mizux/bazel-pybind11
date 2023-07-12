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
	@echo -e "\t${BOLD}<stage>${RESET}: build all <stage> docker images."
	@echo -e "\t${BOLD}<distro>_<stage>${RESET}: build the <stage> docker image for a specific distro."
	@echo -e "\t${BOLD}save_<stage>${RESET}: Save all <stage> docker images."
	@echo -e "\t${BOLD}save_<distro>_<stage>${RESET}: Save the <stage> docker image for a specific distro."
	@echo -e "\t${BOLD}sh_<distro>_<stage>${RESET}: run a container using the <stage> docker image (debug purpose)."
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
	@echo -e "\te.g. 'make ubuntu_test'"
	@echo
	@echo -e "\tBuild using docker buildx with a platform specified."
	@echo -e "\t${BOLD}<platform>_<stage>${RESET}: build <stage> docker images for ALL DISTROS."
	@echo -e "\t${BOLD}<platform>_<distro>_<stage>${RESET}: build <stage> docker image for a specific distro."
	@echo -e "\t${BOLD}save_<platform>_<stage>${RESET}: Save <stage> docker images for ALL DISTROS."
	@echo -e "\t${BOLD}save_<platform>_<distro>_<stage>${RESET}: Save the <stage> docker image for a specific distro."
	@echo -e "\t${BOLD}sh_<platform>_<distro>_<stage>${RESET}: run a container using the <stage> docker image specified (debug purpose)."
	@echo -e "\t${BOLD}clean_<platform>_<distro>_<stage>${RESET}: Remove cache and docker image."
	@echo -e "\t${BOLD}clean_platforms${RESET}: Remove ALL cache and docker image."
	@echo
	@echo -e "\tWith ${BOLD}<platform>${RESET}:"
	@echo -e "\t\t${BOLD}amd64${RESET}: linux/amd64 (x86_64)"
	@echo -e "\t\t${BOLD}386${RESET}: linux/386 (x86)"
	@echo -e "\t\t${BOLD}arm${RESET}: linux/arm (armv7)"
	@echo -e "\t\t${BOLD}arm64${RESET}: linux/arm64 (aarch64, arm64v8)"
	@echo -e "\t\t${BOLD}mips${RESET}: linux/mips (mips 32bits)"
	@echo -e "\t\t${BOLD}mipsle${RESET}: linux/mipsle (mips 32bits Little Endian)"
	@echo -e "\t\t${BOLD}mips64${RESET}: linux/mips64 (mips 64bits)"
	@echo -e "\t\t${BOLD}mips64le${RESET}: linux/mips64le (mips 64bits Little Endian)"
	@echo -e "\t\t${BOLD}ppc64${RESET}: linux/ppc64 (PowerPC 64Bits)"
	@echo -e "\t\t${BOLD}ppc64le${RESET}: linux/ppc64le (PowerPC 64Bits Little Endian)"
	@echo -e "\t\t${BOLD}riscv64${RESET}: linux/riscv64 (RISC-V 64bits)"
	@echo -e "\t\t${BOLD}s390x${RESET}: linux/s390x (IBM System/390x)"
	@echo
	@echo -e "\te.g. 'make amd64_ubuntu_test'"
	@echo -e "\tDocker image unavailable: arm64_archlinux"
	@echo
	@echo -e "\tGlobal targets."
	@echo -e "\t${BOLD}clean${RESET}: Remove ALL caches and docker images."
	@echo -e "\t${BOLD}distclean${RESET}: Remove everything."
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

# $* stem
# $< first prerequist
# $@ target name

# List of stages
STAGES := env devel build test

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
