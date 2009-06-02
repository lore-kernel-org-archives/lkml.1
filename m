Return-Path: <linux-kernel-owner+w=401wt.eu-S1759205AbZFBIZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759205AbZFBIZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 04:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757663AbZFBIZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 04:25:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:54692 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755077AbZFBIZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 04:25:36 -0400
Date: Tue, 2 Jun 2009 08:25:05 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter tools: Make .gitignore reflect perf_counter tools files
Message-ID: <tip-c25486c5ea3ea5586f71285a3aa5cfafb1db59f9@git.kernel.org>
Git-Commit-ID: c25486c5ea3ea5586f71285a3aa5cfafb1db59f9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 02 Jun 2009 08:25:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c25486c5ea3ea5586f71285a3aa5cfafb1db59f9
Gitweb:     http://git.kernel.org/tip/c25486c5ea3ea5586f71285a3aa5cfafb1db59f9
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Tue, 2 Jun 2009 08:09:48 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 2 Jun 2009 09:46:09 +0200

perf_counter tools: Make .gitignore reflect perf_counter tools files

Make .gitignore reflect perf_counter tools files so
git status doesn't gripe about untracked files.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/.gitignore |  187 ++------------------------------
 1 files changed, 12 insertions(+), 175 deletions(-)

diff --git a/Documentation/perf_counter/.gitignore b/Documentation/perf_counter/.gitignore
index 41c0b20..d69a759 100644
--- a/Documentation/perf_counter/.gitignore
+++ b/Documentation/perf_counter/.gitignore
@@ -1,179 +1,16 @@
-GIT-BUILD-OPTIONS
-GIT-CFLAGS
-GIT-GUI-VARS
-GIT-VERSION-FILE
-git
-git-add
-git-add--interactive
-git-am
-git-annotate
-git-apply
-git-archimport
-git-archive
-git-bisect
-git-bisect--helper
-git-blame
-git-branch
-git-bundle
-git-cat-file
-git-check-attr
-git-check-ref-format
-git-checkout
-git-checkout-index
-git-cherry
-git-cherry-pick
-git-clean
-git-clone
-git-commit
-git-commit-tree
-git-config
-git-count-objects
-git-cvsexportcommit
-git-cvsimport
-git-cvsserver
-git-daemon
-git-diff
-git-diff-files
-git-diff-index
-git-diff-tree
-git-difftool
-git-difftool--helper
-git-describe
-git-fast-export
-git-fast-import
-git-fetch
-git-fetch--tool
-git-fetch-pack
-git-filter-branch
-git-fmt-merge-msg
-git-for-each-ref
-git-format-patch
-git-fsck
-git-fsck-objects
-git-gc
-git-get-tar-commit-id
-git-grep
-git-hash-object
-git-help
-git-http-fetch
-git-http-push
-git-imap-send
-git-index-pack
-git-init
-git-init-db
-git-instaweb
-git-log
-git-lost-found
-git-ls-files
-git-ls-remote
-git-ls-tree
-git-mailinfo
-git-mailsplit
-git-merge
-git-merge-base
-git-merge-index
-git-merge-file
-git-merge-tree
-git-merge-octopus
-git-merge-one-file
-git-merge-ours
-git-merge-recursive
-git-merge-resolve
-git-merge-subtree
-git-mergetool
-git-mergetool--lib
-git-mktag
-git-mktree
-git-name-rev
-git-mv
-git-pack-redundant
-git-pack-objects
-git-pack-refs
-git-parse-remote
-git-patch-id
-git-peek-remote
-git-prune
-git-prune-packed
-git-pull
-git-push
-git-quiltimport
-git-read-tree
-git-rebase
-git-rebase--interactive
-git-receive-pack
-git-reflog
-git-relink
-git-remote
-git-repack
-git-repo-config
-git-request-pull
-git-rerere
-git-reset
-git-rev-list
-git-rev-parse
-git-revert
-git-rm
-git-send-email
-git-send-pack
-git-sh-setup
-git-shell
-git-shortlog
-git-show
-git-show-branch
-git-show-index
-git-show-ref
-git-stage
-git-stash
-git-status
-git-stripspace
-git-submodule
-git-svn
-git-symbolic-ref
-git-tag
-git-tar-tree
-git-unpack-file
-git-unpack-objects
-git-update-index
-git-update-ref
-git-update-server-info
-git-upload-archive
-git-upload-pack
-git-var
-git-verify-pack
-git-verify-tag
-git-web--browse
-git-whatchanged
-git-write-tree
-git-core-*/?*
-gitk-wish
-gitweb/gitweb.cgi
-test-chmtime
-test-ctype
-test-date
-test-delta
-test-dump-cache-tree
-test-genrandom
-test-match-trees
-test-parse-options
-test-path-utils
-test-sha1
-test-sigchain
+PERF-BUILD-OPTIONS
+PERF-CFLAGS
+PERF-GUI-VARS
+PERF-VERSION-FILE
+perf
+perf-help
+perf-record
+perf-report
+perf-stat
+perf-top
+perf*.1
+perf*.xml
 common-cmds.h
-*.tar.gz
-*.dsc
-*.deb
-git.spec
-*.exe
-*.[aos]
-*.py[co]
-config.mak
-autom4te.cache
-config.cache
-config.log
-config.status
-config.mak.autogen
-config.mak.append
-configure
 tags
 TAGS
 cscope*
