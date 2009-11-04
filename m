Return-Path: <linux-kernel-owner+w=401wt.eu-S1756678AbZKDP01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbZKDP01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 10:26:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756376AbZKDP0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 10:26:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:57351 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372AbZKDP0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 10:26:22 -0500
Date: Wed, 4 Nov 2009 15:25:58 GMT
From: tip-bot for Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, h-shimamoto@ct.jp.nec.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, h-shimamoto@ct.jp.nec.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
In-Reply-To: <4AF0FBD7.7000501@ct.jp.nec.com>
References: <4AF0FBD7.7000501@ct.jp.nec.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] x86: Gitignore: arch/x86/lib/inat-tables.c
Message-ID: <tip-09879b99d44d701c603935ef2549004405d7f8f9@git.kernel.org>
Git-Commit-ID: 09879b99d44d701c603935ef2549004405d7f8f9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  09879b99d44d701c603935ef2549004405d7f8f9
Gitweb:     http://git.kernel.org/tip/09879b99d44d701c603935ef2549004405d7f8f9
Author:     Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
AuthorDate: Wed, 4 Nov 2009 12:58:15 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Nov 2009 13:11:28 +0100

x86: Gitignore: arch/x86/lib/inat-tables.c

Ignore generated file arch/x86/lib/inat-tables.c.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
LKML-Reference: <4AF0FBD7.7000501@ct.jp.nec.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/lib/.gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/lib/.gitignore b/arch/x86/lib/.gitignore
new file mode 100644
index 0000000..8df89f0
--- /dev/null
+++ b/arch/x86/lib/.gitignore
@@ -0,0 +1 @@
+inat-tables.c
