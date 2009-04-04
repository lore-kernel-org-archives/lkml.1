Return-Path: <linux-kernel-owner+w=401wt.eu-S1761644AbZDDIsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761644AbZDDIsi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 04:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759585AbZDDIs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 04:48:28 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:35860 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbZDDIs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 04:48:28 -0400
Message-ID: <49D71ED5.8000305@larces.uece.br>
Date: Sat, 04 Apr 2009 05:48:21 -0300
From: Sergio Luis <sergio@larces.uece.br>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lauro Salmito <laurosalmito@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@suse.cz>,
       x86 Maintainers <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 5/6] x86: unify power/cpu_(32|64) copyright notes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86: unify power/cpu_(32|64) copyright notes

In this step, we do unify the copyright notes for both files
cpu_32.c and cpu_64.c, making such files exactly the same.
It's the last step before the actual unification, that will
rename one of them to cpu.c and remove the other one.

Signed-off-by: Sergio Luis <sergio@larces.uece.br>
Signed-off-by: Lauro Salmito <laurosalmito@gmail.com>
---
 arch/x86/power/cpu_32.c |    3 ++-
 arch/x86/power/cpu_64.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/power/cpu_32.c b/arch/x86/power/cpu_32.c
index ef656e2..2285ac7 100644
--- a/arch/x86/power/cpu_32.c
+++ b/arch/x86/power/cpu_32.c
@@ -1,8 +1,9 @@
 /*
- * Suspend support specific for i386.
+ * Suspend and hibernation support for i386/x86-64.
  *
  * Distribute under GPLv2
  *
+ * Copyright (c) 2007 Rafael J. Wysocki <rjw@sisk.pl>
  * Copyright (c) 2002 Pavel Machek <pavel@suse.cz>
  * Copyright (c) 2001 Patrick Mochel <mochel@osdl.org>
  */
diff --git a/arch/x86/power/cpu_64.c b/arch/x86/power/cpu_64.c
index 8bd680a..48cce37 100644
--- a/arch/x86/power/cpu_64.c
+++ b/arch/x86/power/cpu_64.c
@@ -1,5 +1,5 @@
 /*
- * Suspend and hibernation support for x86-64
+ * Suspend support specific for i386/x86-64.
  *
  * Distribute under GPLv2
  *
