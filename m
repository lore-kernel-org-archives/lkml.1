Return-Path: <linux-kernel-owner+w=401wt.eu-S1754577AbZKDD73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbZKDD73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 22:59:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754530AbZKDD73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 22:59:29 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:52575 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529AbZKDD72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 22:59:28 -0500
Message-ID: <4AF0FBD7.7000501@ct.jp.nec.com>
Date: Wed, 04 Nov 2009 12:58:15 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: Masami Hiramatsu <mhiramat@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH RESEND] x86: gitignore: arch/x86/lib/inat-tables.c
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Ignore generated file arch/x86/lib/inat-tables.c.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
---
 arch/x86/lib/.gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/lib/.gitignore

diff --git a/arch/x86/lib/.gitignore b/arch/x86/lib/.gitignore
new file mode 100644
index 0000000..8df89f0
--- /dev/null
+++ b/arch/x86/lib/.gitignore
@@ -0,0 +1 @@
+inat-tables.c
-- 
1.6.3.3

