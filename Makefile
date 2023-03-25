WORKDIR := $(PWD)

## Build distribution-ready packages
.PHONY: dist
dist: linux-dist-appimage

.PHONY: build
build: linux-dist-appimage

.PHONY: linux-build-and-run
linux-build-and-run: linux-build linux-run

.PHONY: linux-run
linux-run:
	@echo "# -- Running for Linux"
	$(WORKDIR)/build/linux/gui/chiaki
	@echo

linux-dist-appimage: update-submodules linux-build
	@echo "# -- Building AppImage for Linux"
	$(WORKDIR)/scripts/run-podman-build-appimage.sh
	mkdir -p $(WORKDIR)/dist
	cp $(WORKDIR)/appimage/Chiaki.AppImage $(WORKDIR)/dist/Chiaki.AppImage
	@echo

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
