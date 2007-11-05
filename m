Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbXKERS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbXKERS5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:18:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757839AbXKERIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:08:30 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:59555 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757053AbXKERI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:08:26 -0500
Date: Mon, 5 Nov 2007 18:08:03 +0100
From: Adrian Bunk <bunk@kernel.org>
To: philb@gnu.org, geert@linux-m68k.org, zippel@linux-m68k.org
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] kill arch/m68k/hp300/ksyms.c
Message-ID: <20071105170803.GB12045@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It was empty.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/m68k/hp300/Makefile |    2 +-
 arch/m68k/hp300/ksyms.c  |    9 ---------
 2 files changed, 1 insertion(+), 10 deletions(-)

70b716198e0f5bdfd7ffaaa56d50b61877e58c10 
diff --git a/arch/m68k/hp300/Makefile b/arch/m68k/hp300/Makefile
index 288b9c6..96d4244 100644
--- a/arch/m68k/hp300/Makefile
+++ b/arch/m68k/hp300/Makefile
@@ -2,4 +2,4 @@
 # Makefile for Linux arch/m68k/hp300 source directory
 #
 
-obj-y		:= ksyms.o config.o time.o reboot.o
+obj-y		:= config.o time.o reboot.o
diff --git a/arch/m68k/hp300/ksyms.c b/arch/m68k/hp300/ksyms.c
deleted file mode 100644
index 8202830..0000000
--- a/arch/m68k/hp300/ksyms.c
+++ /dev/null
@@ -1,9 +0,0 @@
-/*
- *  linux/arch/m68k/hp300/ksyms.c
- *
- *  Copyright (C) 1998 Philip Blundell <philb@gnu.org>
- *
- *  This file contains the HP300-specific kernel symbols.  None yet. :-)
- */
-
-#include <linux/module.h>

