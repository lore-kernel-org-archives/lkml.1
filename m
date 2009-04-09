Return-Path: <linux-kernel-owner+w=401wt.eu-S1759979AbZDIEi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759979AbZDIEi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 00:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758432AbZDIEhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 00:37:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:57100 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758894AbZDIEhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 00:37:46 -0400
Date: Thu, 9 Apr 2009 04:37:13 GMT
From: Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <18909.13033.345975.434902@cargo.ozlabs.ibm.com>
References: <18909.13033.345975.434902@cargo.ozlabs.ibm.com>
Subject: [tip:perfcounters/core] perf_counter: add MAINTAINERS entry
Message-ID: <tip-6c0b324435ff49fb3c68fe808a93853d81c7fb97@git.kernel.org>
Git-Commit-ID: 6c0b324435ff49fb3c68fe808a93853d81c7fb97
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 09 Apr 2009 04:37:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6c0b324435ff49fb3c68fe808a93853d81c7fb97
Gitweb:     http://git.kernel.org/tip/6c0b324435ff49fb3c68fe808a93853d81c7fb97
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Thu, 9 Apr 2009 09:27:37 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Apr 2009 05:59:58 +0200

perf_counter: add MAINTAINERS entry

This adds an entry in MAINTAINERS for the perf_counter subsystem.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <18909.13033.345975.434902@cargo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 MAINTAINERS |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c3b2159..16fb45a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3483,6 +3483,16 @@ M:	balbir@linux.vnet.ibm.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
+PERFORMANCE COUNTER SUBSYSTEM
+P:	Peter Zijlstra
+M:	a.p.zijlstra@chello.nl
+P:	Paul Mackerras
+M:	paulus@samba.org
+P:	Ingo Molnar
+M:	mingo@elte.hu
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+
 PERSONALITY HANDLING
 P:	Christoph Hellwig
 M:	hch@infradead.org
