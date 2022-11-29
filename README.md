# libgit2 Swift Package

## Overview

This repository implements a Swift package that builds, includes, and wraps the [libgit2](https://libgit2.org) library. This Swift package provides a Swift API that wraps the libgit2 C APIs and allows macOS, iOS, and iPadOS applications to clone and work with Git repositories.

The libgit2 library that this package builds and wraps was built on top of [libssh2](https://github.com/mfcollins3/libssh2-apple) and [OpenSSL](https://github.com/mfcollins3/openssl-apple).

This Swift package supports the following platforms:

* macOS (Apple Silicone and Intel)
* iOS (64-bit only)
* iOS Simulator (Apple Silicone and Intel)
* macOS Catalyst (Apple Silicone and Intel)

:warning: Please note that in order to use this Swift package, you must also agree to the license terms for libgit2, libssh2, and OpenSSL:

* [libgit2 License](https://github.com/libgit2/libgit2/blob/v1.5.0/COPYING)
* [libssh2 License](https://github.com/libssh2/libssh2/blob/libssh2-1.10.0/COPYING)
* [OpenSSL License](https://github.com/openssl/openssl/blob/openssl-3.0.7/LICENSE.txt)

## Building libgit2

:warning: Building libgit2 requires you to have installed and build the following prerequisite frameworks first:

- [OpenSSL](https://github.com/mfcollins3/openssl-apple)
- [libssh2](https://github.com/mfcollins3/libssh2-apple)

The build process for libgit2 assumes that OpenSSL and libssh2 are siblings in the same parent directory of the file system and will look for them in the `../openssl-apple` and `../libssh2-apple` paths.

If you need to build libgit2 yourself, I have provided the [build.sh](build.sh) program to automate the process. This program will build libgit2 for all supported platforms and will produce the XCFramework containing the libraries and header files for each platform.

This repository includes the source code for libgit2 as a Git submodule. To begin, you need to close the repository and load the submodules:

```sh
git clone https://github.com/mfcollins3/libgit2-apple.git
cd libssh2-apple
git submodule init
git submodule update
```

After cloning the repository, you can run the `build.sh` program without any arguments to build the libgit2 library and produce the XCFramework.
