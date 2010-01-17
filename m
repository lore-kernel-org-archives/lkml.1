Return-Path: <linux-kernel-owner+w=401wt.eu-S1754979Ab0AQV2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab0AQV2Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 16:28:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754614Ab0AQV2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 16:28:24 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:39745 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab0AQV2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 16:28:23 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: trivial@kernel.org
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
       linux-doc@vger.kernel.org
Subject: [PATCH] trivial: fix typo s/programme/program/ in mtrr documentation
Date: Sun, 17 Jan 2010 19:25:51 -0200
Message-Id: <1263763552-9656-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 Documentation/x86/mtrr.txt |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/x86/mtrr.txt b/Documentation/x86/mtrr.txt
index cc071dc..3ffcbea 100644
--- a/Documentation/x86/mtrr.txt
+++ b/Documentation/x86/mtrr.txt
@@ -195,11 +195,11 @@ int main ()
     exit (3);
 }   /*  End Function main  */
 ===============================================================================
-Creating MTRRs from a C programme using ioctl()'s:
+Creating MTRRs from a C program using ioctl()'s:
 
 /*  mtrr-add.c
 
-    Source file for mtrr-add (example programme to add an MTRRs using ioctl())
+    Source file for mtrr-add (example program to add MTRRs using ioctl())
 
     Copyright (C) 1997-1998  Richard Gooch
 
@@ -223,7 +223,7 @@ Creating MTRRs from a C programme using ioctl()'s:
 */
 
 /*
-    This programme will use an ioctl() on /proc/mtrr to add an entry. The first
+    This program will use an ioctl() on /proc/mtrr to add an entry. The first
     available mtrr is used. This is an alternative to writing /proc/mtrr.
 
 
-- 
1.6.6

