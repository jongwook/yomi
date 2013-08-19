//
//  ObjectiveGit.h
//  ObjectiveGitFramework
//
//  Created by Josh Abernathy on 3/3/11.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "git2.h"

#import <GTRepository.h>
#import <GTEnumerator.h>
#import <GTCommit.h>
#import <GTSignature.h>
#import <GTTree.h>
#import <GTTreeEntry.h>
#import <GTTreeBuilder.h>
#import <GTBlob.h>
#import <GTTag.h>
#import <GTIndex.h>
#import <GTIndexEntry.h>
#import <GTReference.h>
#import <GTBranch.h>
#import <GTObject.h>
#import <GTRemote.h>
#import <GTConfiguration.h>
#import <GTReflog.h>
#import <GTReflogEntry.h>
#import <GTOID.h>
#import <GTSubmodule.h>

#import <GTObjectDatabase.h>
#import <GTOdbObject.h>

#import <NSError+Git.h>
#import <NSData+Git.h>
#import <NSString+Git.h>

#import <GTDiff.h>
#import <GTDiffDelta.h>
#import <GTDiffFile.h>
#import <GTDiffHunk.h>
#import <GTDiffLine.h>

// This must be called before doing any ObjectiveGit work.  Under normal
// circumstances, it will automatically be called on your behalf.
// If you've linked ObjectiveGit as a static library but haven't set
// the -all_load linker flag, you'll have to call this manually.
extern void GTSetupThreads(void);

// If you called GTSetupThreads, you must call this after all your ObjectiveGit 
// work is done before your app quits.
extern void GTShutdownThreads(void);
