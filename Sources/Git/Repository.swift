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

import Foundation
import CGit

public final class Repository {
	private let repository: OpaquePointer

	public var commonURL: URL {
		let cString = git_repository_commondir(repository)
		return URL(
			fileURLWithPath: String(cString: cString!),
			isDirectory: true
		)
	}

	init(repository: OpaquePointer) {
		self.repository = repository
	}

	public static func create(
		at url: URL,
		isBare bare: Bool = false
	) throws -> Self {
		var repository: OpaquePointer? = nil
		let errorCode = git_repository_init(
			&repository,
			url.path,
			bare ? 1 : 0
		)
		guard errorCode == 0 else {
			throw GitError.error(Int(errorCode))
		}

		return .init(repository: repository!)
	}

	deinit {
		git_repository_free(repository)
	}
}
