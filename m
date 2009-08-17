Return-Path: <linux-kernel-owner+w=401wt.eu-S932213AbZHQIqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213AbZHQIqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 04:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757446AbZHQIqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 04:46:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:58964 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757445AbZHQIqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 04:46:37 -0400
Date: Mon, 17 Aug 2009 08:46:07 GMT
From: "tip-bot for Carlos R. Mafra" <crmafra@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, crmafra@gmail.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, crmafra@gmail.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/urgent] perf: Rename perf-examples.txt to examples.txt
Message-ID: <tip-2932cffc89e9a1476b28a59896fa4f81e0d4f131@git.kernel.org>
Git-Commit-ID: 2932cffc89e9a1476b28a59896fa4f81e0d4f131
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 17 Aug 2009 08:46:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2932cffc89e9a1476b28a59896fa4f81e0d4f131
Gitweb:     http://git.kernel.org/tip/2932cffc89e9a1476b28a59896fa4f81e0d4f131
Author:     Carlos R. Mafra <crmafra@gmail.com>
AuthorDate: Mon, 17 Aug 2009 00:36:21 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 17 Aug 2009 10:43:42 +0200

perf: Rename perf-examples.txt to examples.txt

Rename it to examples.txt to avoid the perf-*.txt pattern in
the Makefile, otherwise 'make doc' fails because
perf-examples.txt is not formatted to be a man page:

 ERROR: perf-examples.txt: line 1: manpage document title is mandatory

Signed-off-by: Carlos R. Mafra <crmafra@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 .../{perf-examples.txt => examples.txt}            |    0
 1 files changed, 0 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Documentation/perf-examples.txt b/tools/perf/Documentation/examples.txt
similarity index 100%
rename from tools/perf/Documentation/perf-examples.txt
rename to tools/perf/Documentation/examples.txt
