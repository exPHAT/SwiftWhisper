# SwiftWhisper

A Swift wrapper for [whisper.cpp](https://github.com/ggerganov/whisper.cpp)

## Using as a package in your project

In Xcode: File -> Add Packages

Enter package URL: `https://github.com/exPHAT/Whisper`

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
