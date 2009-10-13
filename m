Return-Path: <linux-kernel-owner+w=401wt.eu-S1759926AbZJMNf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759926AbZJMNf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 09:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759911AbZJMNf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 09:35:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:58797 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759901AbZJMNf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 09:35:56 -0400
Date: Tue, 13 Oct 2009 13:34:14 GMT
From: tip-bot for Vincent Legoll <vincent.legoll@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@osdl.org, vincent.legoll@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       vincent.legoll@gmail.com, torvalds@osdl.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4727185d0910130548p325f0185vf4e23b5491c730a0@mail.gmail.com>
References: <4727185d0910130548p325f0185vf4e23b5491c730a0@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf events: Update MAINTAINERS entry file patterns
Message-ID: <tip-a003236c32706f3c1f74d4e3b98c58cf0d9a9d8f@git.kernel.org>
Git-Commit-ID: a003236c32706f3c1f74d4e3b98c58cf0d9a9d8f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 13 Oct 2009 13:34:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a003236c32706f3c1f74d4e3b98c58cf0d9a9d8f
Gitweb:     http://git.kernel.org/tip/a003236c32706f3c1f74d4e3b98c58cf0d9a9d8f
Author:     Vincent Legoll <vincent.legoll@gmail.com>
AuthorDate: Tue, 13 Oct 2009 14:48:14 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 13 Oct 2009 15:28:52 +0200

perf events: Update MAINTAINERS entry file patterns

Add file patterns that match relevant files for this subsystem.

Signed-off-by: Vincent Legoll <vincent.legoll@gmail.com>
Cc: Linus Torvalds <torvalds@osdl.org>
Cc: paulus@samba.org
Cc: a.p.zijlstra@chello.nl
LKML-Reference: <4727185d0910130548p325f0185vf4e23b5491c730a0@mail.gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 MAINTAINERS |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 69e31aa..cf69091 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4071,6 +4071,13 @@ M:	Peter Zijlstra <a.p.zijlstra@chello.nl>
 M:	Paul Mackerras <paulus@samba.org>
 M:	Ingo Molnar <mingo@elte.hu>
 S:	Supported
+F:	kernel/perf_event.c
+F:	include/linux/perf_event.h
+F:	arch/*/*/kernel/perf_event.c
+F:	arch/*/include/asm/perf_event.h
+F:	arch/*/lib/perf_event.c
+F:	arch/*/kernel/perf_callchain.c
+F:	tools/perf/
 
 PERSONALITY HANDLING
 M:	Christoph Hellwig <hch@infradead.org>
