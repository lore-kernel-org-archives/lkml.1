Return-Path: <linux-kernel-owner+w=401wt.eu-S1755776AbZEQXhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776AbZEQXhu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 19:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755376AbZEQXgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 19:36:51 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:46378 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554AbZEQXgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 19:36:47 -0400
From: Markus Heidelberg <markus.heidelberg@web.de>
To: Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       Markus Heidelberg <markus.heidelberg@web.de>
Subject: [PATCH resend 01/10] kconfig: fix typo "mconfig" to "menuconfig" in a comment
Date: Mon, 18 May 2009 01:36:45 +0200
Message-Id: <1242603414-9267-2-git-send-email-markus.heidelberg@web.de>
X-Mailer: git-send-email 1.6.3.1.20.ga30f
In-Reply-To: <1242603414-9267-1-git-send-email-markus.heidelberg@web.de>
References: <1242603414-9267-1-git-send-email-markus.heidelberg@web.de>
X-Provags-ID: V01U2FsdGVkX1/SX0k64jEaRRK4TFBgqQ1n0X2Ubq7u/MHd5Gc2
	AyTm48Yf+VmqjtZd+zeBAwuRPauH9x+O8sBp2+T0QA7FR+kI6d
	43dDqvUeE0fniYNSwdSw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Markus Heidelberg <markus.heidelberg@web.de>
---
 scripts/kconfig/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index fa8c2dd..47e3f2e 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -104,7 +104,7 @@ HOST_EXTRACFLAGS += -DLOCALE
 # ===========================================================================
 # Shared Makefile for the various kconfig executables:
 # conf:	  Used for defconfig, oldconfig and related targets
-# mconf:  Used for the mconfig target.
+# mconf:  Used for the menuconfig target
 #         Utilizes the lxdialog package
 # qconf:  Used for the xconfig target
 #         Based on QT which needs to be installed to compile it
-- 
1.6.3.1.20.ga30f

