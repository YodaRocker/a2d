targets := desktop desktop.system desk.acc selector

.PHONY: all $(targets) mount install installsel package

all: $(targets)

# Build all targets
$(targets):
	@tput setaf 3 && echo "Building: $@" && tput sgr0
	@$(MAKE) -C $@ \
	  && (tput setaf 2 && echo "make $@ good" && tput sgr0) \
          || (tput blink && tput setaf 1 && echo "MAKE $@ BAD" && tput sgr0 && false)

# Optional target: populate mount/ as a mountable directory for Virtual ][
mount:
	res/mount.sh

# Optional target: run install script. Requires Cadius, and INSTALL_IMG and INSTALL_PATH to be set.
install:
	res/install.sh

# Optional target: run install script. Requires Cadius, and INSTALL_IMG and INSTALL_PATH to be set.
installsel:
	res/install.sh selector

# Optional target: run package script. Requires Cadius.
package:
	res/package.sh

# Optional target: make ShrinkIt archive. Requires NuLib2.
shk:
	res/shk.sh

# Clean all temporary/target files
clean:
	@for dir in $(targets); do \
	  tput setaf 2 && echo "cleaning $$dir" && tput sgr0; \
	  $(MAKE) -C $$dir clean; \
	done
