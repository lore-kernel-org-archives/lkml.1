Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbZFEXoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbZFEXoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 19:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756078AbZFEXld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 19:41:33 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:36418 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757AbZFEXlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 19:41:12 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Markus Heidelberg <markus.heidelberg@web.de>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 23/39] kconfig: fix typo "mconfig" to "menuconfig" in a comment
Date: Sat,  6 Jun 2009 01:42:41 +0200
Message-Id: <1244245377-17441-23-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.3.rc3.40.g75b44
In-Reply-To: <20090605233720.GA13588@uranus.ravnborg.org>
References: <20090605233720.GA13588@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Heidelberg <markus.heidelberg@web.de>

Signed-off-by: Markus Heidelberg <markus.heidelberg@web.de>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
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
1.6.3.rc3.40.g75b44

