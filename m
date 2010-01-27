Return-Path: <linux-kernel-owner+w=401wt.eu-S1754671Ab0A0NRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab0A0NRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 08:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629Ab0A0NRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 08:17:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:60555 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754624Ab0A0NRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 08:17:46 -0500
Date: Wed, 27 Jan 2010 13:17:16 GMT
From: tip-bot for Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mingo@elte.hu, amwang@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, amwang@redhat.com, mingo@elte.hu
In-Reply-To: <20100125051052.3999.28082.sendpatchset@localhost.localdomain>
References: <20100125051052.3999.28082.sendpatchset@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Ignore perf.data.old
Message-ID: <tip-7f5102ca4b8a8e598dbfa154322ea684bc98da96@git.kernel.org>
Git-Commit-ID: 7f5102ca4b8a8e598dbfa154322ea684bc98da96
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Jan 2010 13:17:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7f5102ca4b8a8e598dbfa154322ea684bc98da96
Gitweb:     http://git.kernel.org/tip/7f5102ca4b8a8e598dbfa154322ea684bc98da96
Author:     Amerigo Wang <amwang@redhat.com>
AuthorDate: Mon, 25 Jan 2010 00:07:30 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 27 Jan 2010 11:31:26 +0100

perf: Ignore perf.data.old

Tell git to ignore this file.

Signed-off-by: WANG Cong <amwang@redhat.com>
LKML-Reference: <20100125051052.3999.28082.sendpatchset@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/.gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/.gitignore b/tools/perf/.gitignore
index fe08660..124760b 100644
--- a/tools/perf/.gitignore
+++ b/tools/perf/.gitignore
@@ -13,6 +13,7 @@ perf*.xml
 perf*.html
 common-cmds.h
 perf.data
+perf.data.old
 tags
 TAGS
 cscope*
