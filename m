Return-Path: <linux-kernel-owner+w=401wt.eu-S933676AbZKXQ6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933676AbZKXQ6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 11:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933658AbZKXQ5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 11:57:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:60345 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933566AbZKXQ5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 11:57:51 -0500
Date: Tue, 24 Nov 2009 16:57:19 GMT
From: tip-bot for John Kacur <jkacur@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jkacur@redhat.com, fweisbec@gmail.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1259073301-11506-2-git-send-email-jkacur@redhat.com>
References: <1259073301-11506-2-git-send-email-jkacur@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add perf.data to .gitignore
Message-ID: <tip-c9c7ccaf3a2686ed3a44d69bb1f8b55eeead8a4e@git.kernel.org>
Git-Commit-ID: c9c7ccaf3a2686ed3a44d69bb1f8b55eeead8a4e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c9c7ccaf3a2686ed3a44d69bb1f8b55eeead8a4e
Gitweb:     http://git.kernel.org/tip/c9c7ccaf3a2686ed3a44d69bb1f8b55eeead8a4e
Author:     John Kacur <jkacur@redhat.com>
AuthorDate: Tue, 24 Nov 2009 15:35:00 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 24 Nov 2009 16:37:01 +0100

perf tools: Add perf.data to .gitignore

Signed-off-by: John Kacur <jkacur@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: acme@redhat.com
LKML-Reference: <1259073301-11506-2-git-send-email-jkacur@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/.gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/.gitignore b/tools/perf/.gitignore
index 0854f11..fe08660 100644
--- a/tools/perf/.gitignore
+++ b/tools/perf/.gitignore
@@ -12,6 +12,7 @@ perf*.1
 perf*.xml
 perf*.html
 common-cmds.h
+perf.data
 tags
 TAGS
 cscope*
