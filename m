Return-Path: <linux-kernel-owner+w=401wt.eu-S1760086AbZFWOnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760086AbZFWOnh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 10:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757347AbZFWOn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 10:43:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:55310 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753718AbZFWOn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 10:43:28 -0400
Date: Tue, 23 Jun 2009 14:42:53 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       Brice.Goglin@inria.fr, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, Brice.Goglin@inria.fr,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/urgent] perf report: Fix help text typo
Message-ID: <tip-b0a28589b2fc9bee8ed83dee006a497d1ce93841@git.kernel.org>
Git-Commit-ID: b0a28589b2fc9bee8ed83dee006a497d1ce93841
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 23 Jun 2009 14:42:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b0a28589b2fc9bee8ed83dee006a497d1ce93841
Gitweb:     http://git.kernel.org/tip/b0a28589b2fc9bee8ed83dee006a497d1ce93841
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 23 Jun 2009 16:39:53 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 23 Jun 2009 16:39:53 +0200

perf report: Fix help text typo

Reported-by: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/Documentation/perf-report.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 52d3fc6..40c1db8 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -13,7 +13,7 @@ SYNOPSIS
 DESCRIPTION
 -----------
 This command displays the performance counter profile information recorded
-via perf report.
+via perf record.
 
 OPTIONS
 -------
