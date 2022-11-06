# whisper.spm

[whisper.cpp](https://github.com/ggerganov/whisper.cpp) package for the Swift Package Manager

## Using as a package in your project

In XCode: File -> Swift Packages -> Add Package Dependency

Enter package URL: `https://github.com/ggerganov/whisper.spm`

## Build package from command line

```bash
git clone https://github.com/ggeragnov/whisper.spm
cd whisper.spm

# if building standalone
make build

# if building as a submodule for whisper.cpp
make build-submodule

# run tests
.build/debug/test-objc
.build/debug/test-swift
```
