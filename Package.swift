// swift-tools-version: 5.7

// Copyright 2022 Michael F. Collins, III
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restrictions, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.

import PackageDescription

let package = Package(
    name: "Git",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_13)
    ],
    products: [
        .library(
            name: "Git",
            targets: ["Git"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/mfcollins3/libssh2-apple.git",
            .upToNextMajor(from: "0.1.0")
        )
    ],
    targets: [
        .target(
            name: "Git",
            dependencies: [
                "CGit",
				"libgit2",
				.product(name: "SSH2", package: "libssh2-apple")
            ]
        ),
        .target(
            name: "CGit",
            publicHeadersPath: "./",
			linkerSettings: [
				.linkedLibrary("iconv"),
				.linkedLibrary("z")
			]
        ),
        .binaryTarget(
            name: "libgit2",
            url: "https://github.com/mfcollins3/libgit2-apple/releases/download/0.1.0/libgit2.zip",
            checksum: "488ea08d20ea4a651f56d271e8f793e92f07dd03e77447ab8dfd8846680a9cae"
        )
    ]
)
