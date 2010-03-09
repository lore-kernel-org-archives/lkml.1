Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab0CIIW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 03:22:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:57273 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785Ab0CIIW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 03:22:27 -0500
Date: Tue, 9 Mar 2010 08:21:45 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] MAINTAINERS: Add Arnaldo as tools/perf/ co-maintainer
Message-ID: <tip-cfb581bcd4f8c158c6f2b48bf5e232bb9e6855c0@git.kernel.org>
Git-Commit-ID: cfb581bcd4f8c158c6f2b48bf5e232bb9e6855c0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 09 Mar 2010 08:21:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cfb581bcd4f8c158c6f2b48bf5e232bb9e6855c0
Gitweb:     http://git.kernel.org/tip/cfb581bcd4f8c158c6f2b48bf5e232bb9e6855c0
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Mon, 8 Mar 2010 15:20:50 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 9 Mar 2010 07:03:48 +0100

MAINTAINERS: Add Arnaldo as tools/perf/ co-maintainer

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Paul Mackerras <paulus@samba.org>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2533fc4..40ed22e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4221,6 +4221,7 @@ PERFORMANCE EVENTS SUBSYSTEM
 M:	Peter Zijlstra <a.p.zijlstra@chello.nl>
 M:	Paul Mackerras <paulus@samba.org>
 M:	Ingo Molnar <mingo@elte.hu>
+M:	Arnaldo Carvalho de Melo <acme@redhat.com>
 S:	Supported
 F:	kernel/perf_event.c
 F:	include/linux/perf_event.h
