Return-Path: <linux-kernel-owner+w=401wt.eu-S1751893AbZJPIlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893AbZJPIlj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 04:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264AbZJPIli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 04:41:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:43612 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbZJPIlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 04:41:37 -0400
Date: Fri, 16 Oct 2009 08:40:22 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Bump version to 0.0.2
Message-ID: <tip-210f9cb2cf2effca690271085f4bd6a3ea286e6c@git.kernel.org>
Git-Commit-ID: 210f9cb2cf2effca690271085f4bd6a3ea286e6c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 16 Oct 2009 08:40:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  210f9cb2cf2effca690271085f4bd6a3ea286e6c
Gitweb:     http://git.kernel.org/tip/210f9cb2cf2effca690271085f4bd6a3ea286e6c
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 16 Oct 2009 10:34:28 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 16 Oct 2009 10:34:28 +0200

perf tools: Bump version to 0.0.2

We released the first version of perf with 0.0.1 in v2.6.31,
time to double our version number to 0.0.2 ;-)

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/PERF-VERSION-GEN |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/PERF-VERSION-GEN b/tools/perf/util/PERF-VERSION-GEN
index c561d15..54552a0 100755
--- a/tools/perf/util/PERF-VERSION-GEN
+++ b/tools/perf/util/PERF-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=PERF-VERSION-FILE
-DEF_VER=v0.0.1.PERF
+DEF_VER=v0.0.2.PERF
 
 LF='
 '
