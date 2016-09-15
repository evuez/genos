TARGETS=.targets


.PHONY: build
build: $(TARGETS)/build

.PHONY: iex
iex:
	docker run -t -i -v $(shell pwd):/genos genos:latest iex -S mix


$(TARGETS)/build: Dockerfile
	docker build --tag="genos:latest" .
	touch $@

