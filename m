Return-Path: <linux-kernel-owner+w=401wt.eu-S1755157AbZKIMBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbZKIMBG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 07:01:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbZKIMBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 07:01:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:47167 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbZKIMBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 07:01:03 -0500
Date: Mon, 9 Nov 2009 12:00:37 GMT
From: tip-bot for Zeev Tarantov <zeev.tarantov@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, zeev.tarantov@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, zeev.tarantov@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12d7e64c0911081811i7e5b466cu6706ff6ab3e70db4@mail.gmail.com>
References: <12d7e64c0911081811i7e5b466cu6706ff6ab3e70db4@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix syntax in documentation
Message-ID: <tip-ca2b900f9af1586b9889ccc4b12e453c13268bd5@git.kernel.org>
Git-Commit-ID: ca2b900f9af1586b9889ccc4b12e453c13268bd5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ca2b900f9af1586b9889ccc4b12e453c13268bd5
Gitweb:     http://git.kernel.org/tip/ca2b900f9af1586b9889ccc4b12e453c13268bd5
Author:     Zeev Tarantov <zeev.tarantov@gmail.com>
AuthorDate: Mon, 9 Nov 2009 13:26:13 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 9 Nov 2009 12:58:04 +0100

perf tools: Fix syntax in documentation

Fix trivial syntax in perf-events user-space tools
documentation.

Signed-off-by: Zeev Tarantov <zeev.tarantov@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <12d7e64c0911081811i7e5b466cu6706ff6ab3e70db4@mail.gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Documentation/perf-report.txt |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 59f0b84..9dccb18 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -24,11 +24,11 @@ OPTIONS
 --dsos=::
 	Only consider symbols in these dsos. CSV that understands
 	file://filename entries.
--n
---show-nr-samples
+-n::
+--show-nr-samples::
 	Show the number of samples for each symbol
--T
---threads
+-T::
+--threads::
 	Show per-thread event counters
 -C::
 --comms=::
