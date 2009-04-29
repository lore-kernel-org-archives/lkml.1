Return-Path: <linux-kernel-owner+w=401wt.eu-S1758908AbZD2JKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758908AbZD2JKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 05:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758018AbZD2JHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 05:07:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:60550 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757968AbZD2JHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 05:07:23 -0400
Date: Wed, 29 Apr 2009 09:05:51 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, sam@ravnborg.org, tabbott@MIT.EDU,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, torvalds@linux-foundation.org, tabbott@MIT.EDU,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1240991249-27117-2-git-send-email-sam@ravnborg.org>
References: <1240991249-27117-2-git-send-email-sam@ravnborg.org>
Subject: [tip:x86/kbuild] x86, vmlinux.lds: add copyright
Message-ID: <tip-91fd7fe809bdf4d8aa56559d17b9f25a1a6fe732@git.kernel.org>
Git-Commit-ID: 91fd7fe809bdf4d8aa56559d17b9f25a1a6fe732
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 09:05:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  91fd7fe809bdf4d8aa56559d17b9f25a1a6fe732
Gitweb:     http://git.kernel.org/tip/91fd7fe809bdf4d8aa56559d17b9f25a1a6fe732
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 29 Apr 2009 10:58:38 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 11:00:25 +0200

x86, vmlinux.lds: add copyright

Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <1240991249-27117-2-git-send-email-sam@ravnborg.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/vmlinux.lds.S |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index ef3e4f1..0bdbaa5 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -3,7 +3,8 @@
  *
  * Historic 32-bit version written by Martin Mares <mj@atrey.karlin.mff.cuni.cz>
  *
- * Modernisation and unification done by Sam Ravnborg <sam@ravnborg.org>
+ * Modernisation, unification and other changes and fixes:
+ *   Copyright (C) 2007-2009  Sam Ravnborg <sam@ravnborg.org>
  *
  *
  * Don't define absolute symbols until and unless you know that symbol
