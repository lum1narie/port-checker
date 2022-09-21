OUTDIR=build

.PHONY: all
all: portChecker

%: %.nim
	nim c -d:ssl -d:release --opt:size -o:$(OUTDIR)/$@ $<

.PHONY: fmt
fmt:
	bash -c 'shopt -s globstar; nimpretty **/*.nim'
