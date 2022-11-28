# libgit2 Swift Package

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
