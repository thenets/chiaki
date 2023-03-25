WORKDIR := $(PWD)

.PHONY: build
build: update-submodules linux-build

.PHONY: linux-build-and-run
linux-build-and-run: linux-build linux-run

.PHONY: linux-run
linux-run:
	@echo "# -- Running for Linux"
	$(WORKDIR)/build/linux/gui/chiaki

.PHONY: linux-all
linux-all: linux-install-dependencies linux-build

.PHONY: linux-build
linux-build:
	@echo "# -- Building for Linux"
	mkdir -p $(WORKDIR)/build/linux
	cd $(WORKDIR)/build/linux && cmake $(WORKDIR)
	cd $(WORKDIR)/build/linux && make
	@echo

.PHONY: linux-install-dependencies
linux-install-dependencies:
	@echo "# -- Installing dependencies"
	sudo dnf install -y \
		cmake gcc-c++ pkgconfig \
		libavutil-free-devel libswresample-free-devel \
		libswscale-free-devel libavcodec-free-devel \
		protobuf-devel \
		python3-protobuf \
		opus-devel \
		SDL2-devel \
		qt5-qtbase-devel qt5-qtmultimedia-devel qt5-qtsvg-devel 

.PHONY: update-submodules
update-submodules:
	@echo "# -- Updating submodules"
	git submodule update --init
	@echo
