CURDIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

ifeq ($(firstword $(MAKECMDGOALS)), issue)
	SITE_HOST := $(wordlist 2, 2, $(MAKECMDGOALS))
endif

all:
	@echo Usage:
	@echo make image
	@echo make issue
	@echo make issue www.hoge.com
	@echo make shell

# Build a docker image.
image:
	docker build --tag=abctrusti .

# Issue a certificate
.PHONY: issue shell
issue:
	docker run --rm -it \
		-v $(CURDIR):/tmp/work \
		--name abctrust \
		-e SITE_HOST=$(SITE_HOST) \
		abctrusti ./issue.sh

# Work on shell.
shell:
	docker run --rm -it \
		-v $(CURDIR):/tmp/work \
		--name abctrust \
		abctrusti

.SILENT:
%:
	@:

