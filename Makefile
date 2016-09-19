TARGETS=.targets


.PHONY: build
build: $(TARGETS)/build


.PHONY: iex
iex:
	docker run -t -i -v $(shell pwd):/genos genos:latest iex -S mix

.PHONY: deps
deps:
	docker run -t -i -v $(shell pwd):/genos genos:latest mix do deps.get, compile


$(TARGETS)/build: Dockerfile
	docker build --tag="genos:latest" .
	touch $@
