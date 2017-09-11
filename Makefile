EXE = cmeta
SOURCES = $(wildcard src/*.rkt)

all: build/$(EXE)

build/$(EXE): $(SOURCES) | build/
	raco exe -o build/$(EXE) src/main.rkt

run: build/$(EXE)
	./build/$(EXE) --help

test: build/$(EXE)
	./build/$(EXE) -g test.c

build/:
	mkdir -p build/

clean:
	rm -rf build/
