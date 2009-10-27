Return-Path: <linux-kernel-owner+w=401wt.eu-S1755947AbZJ0BSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbZJ0BSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 21:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755564AbZJ0BSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 21:18:37 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:32952 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391AbZJ0BSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 21:18:36 -0400
Message-ID: <4AE64A02.9010403@ct.jp.nec.com>
Date: Tue, 27 Oct 2009 10:16:50 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: gitignore: arch/x86/lib/inat-tables.c
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Ignore generated file arch/x86/lib/inat-tables.c.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
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

