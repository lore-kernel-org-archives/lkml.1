Return-Path: <linux-kernel-owner+w=401wt.eu-S1760885AbZDSNlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760885AbZDSNlf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 09:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758482AbZDSNlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 09:41:22 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:32804 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758111AbZDSNlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 09:41:20 -0400
From: Markus Heidelberg <markus.heidelberg@web.de>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       Markus Heidelberg <markus.heidelberg@web.de>
Subject: [PATCH 01/10] kconfig: fix typo "mconfig" to "menuconfig" in a comment
Date: Sun, 19 Apr 2009 15:41:18 +0200
Message-Id: <1240148487-27584-2-git-send-email-markus.heidelberg@web.de>
X-Mailer: git-send-email 1.6.3.rc1.24.g467d50
In-Reply-To: <1240148487-27584-1-git-send-email-markus.heidelberg@web.de>
References: <1240148487-27584-1-git-send-email-markus.heidelberg@web.de>
X-Provags-ID: V01U2FsdGVkX1/Rn10JimVdeoZcrxLh+hGE4MTliQuHFTP9x9vT
	m5MqWw7hxAkB4VZMiQeTQ7l1S/W2x0b5Dvm50WVvXfa9YzTD0U
	0vHOab+pGHUcx+eDEPTg==
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
1.6.3.rc1.24.g467d50

