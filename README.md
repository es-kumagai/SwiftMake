# Layout

* ./swift-make (This Project)
	* toolchains
	* swift-nightly-install
* ./swift-source (Swift OpenSource)
* ./swift-test (Test codes for Swift)

# How to use

```
cd ./swift-make

make
```

## Targets

* make swift
	* build Swift for debug without testing.
* make test
	* build Swift for debug with testing.
* make release
	* build Swift for release.
* make toolchain
	* generate Swift Toolchain.
* make xcode
	* generate Xcode Project for Swift.
* make swiftpm
	* build Swift Package Manager


