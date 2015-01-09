GEM_NAME := tablerize

all:
	gem build $(GEM_NAME).gemspec

install: all
	gem install $(GEM_NAME)

uninstall:
	gem uninstall $(GEM_NAME)

clean:
	rm -fv -- $(GEM_NAME)-*.gem

.PHONY: all install clean
