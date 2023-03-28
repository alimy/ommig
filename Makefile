GOFMT ?= gofmt -s -w
GOFILES := $(shell find . -name "*.go" -type f)

LDFLAGS += -X "github.com/alimy/ommig/version.BuildTime=$(shell date -v+8H -u '+%Y-%m-%d %H:%M:%S %Z+8')"
LDFLAGS += -X "github.com/alimy/ommig/version.GitHash=$(shell git rev-parse --short=12 HEAD)"

RELEASE_ROOT = release
TARGET = ommig
RELEASE_LINUX_AMD64 = $(RELEASE_ROOT)/linux-amd64/$(TARGET)
RELEASE_DARWIN_AMD64 = $(RELEASE_ROOT)/darwin-amd64/$(TARGET)
RELEASE_DARWIN_ARM64 = $(RELEASE_ROOT)/darwin-arm64/$(TARGET)
RELEASE_WINDOWS_AMD64 = $(RELEASE_ROOT)/windows-amd64/$(TARGET)

STYLES = chi hertz echo fiber fiber-v2 gin httprouter iris macaron mux

.PHONY: build
build: fmt
	go build  -ldflags '$(LDFLAGS)' -o $(RELEASE_ROOT)/$(TARGET)

.PHONY: release
release: linux-amd64 darwin-amd64 darwin-arm64 windows-x64
	cp LICENSE README.md $(RELEASE_LINUX_AMD64)
	cp LICENSE README.md $(RELEASE_DARWIN_AMD64)
	cp LICENSE README.md $(RELEASE_DARWIN_ARM64)
	cp LICENSE README.md $(RELEASE_WINDOWS_AMD64)
	cd $(RELEASE_LINUX_AMD64)/.. && rm -f *.zip && zip -r $(TARGET)-linux_amd64.zip $(TARGET) && cd -
	cd $(RELEASE_DARWIN_AMD64)/.. && rm -f *.zip && zip -r $(TARGET)-darwin_amd64.zip $(TARGET) && cd -
	cd $(RELEASE_DARWIN_ARM64)/.. && rm -f *.zip && zip -r $(TARGET)-darwin_arm64.zip $(TARGET) && cd -
	cd $(RELEASE_WINDOWS_AMD64)/.. && rm -f *.zip && zip -r $(TARGET)-windows_amd64.zip $(TARGET) && cd -

.PHONY: linux-amd64
linux-amd64:
	GOOS=linux GOARCH=amd64 go build  -ldflags '$(LDFLAGS)' -o $(RELEASE_LINUX_AMD64)/$(TARGET)

.PHONY: darwin-amd64
darwin-amd64:
	GOOS=darwin GOARCH=amd64 go build  -ldflags '$(LDFLAGS)' -o $(RELEASE_DARWIN_AMD64)/$(TARGET)

.PHONY: darwin-arm64
darwin-arm64:
	GOOS=darwin GOARCH=arm64 go build  -ldflags '$(LDFLAGS)' -o $(RELEASE_DARWIN_ARM64)/$(TARGET)

.PHONY: windows-x64
windows-x64:
	GOOS=windows GOARCH=amd64 go build  -ldflags '$(LDFLAGS)' -o $(RELEASE_WINDOWS_AMD64)/$(TARGET)

.PHONY: fmt
fmt:
	$(GOFMT) $(GOFILES)

.PHONY: check-all
check-all:
	@for target in $(STYLES); do \
	  echo "==========[ processing $$target ]=========="; \
	  rm -rf $$target; \
	  ./release/ommig new --style $$target --pkg github.com/alimy/mir-$$target --dst out/$$target; \
	  cd out/$$target; \
	  make mod-tidy; \
	  cd -; \
	  echo ""; \
	done

.PHONY: clean
clean:
	-rm -rf out
