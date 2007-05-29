Return-Path: <linux-kernel-owner+w=401wt.eu-S1764772AbXE2Kpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764772AbXE2Kpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 06:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757701AbXE2KpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 06:45:19 -0400
Received: from mx0.karneval.cz ([81.27.192.14]:59080 "EHLO av6.karneval.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757687AbXE2KpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 06:45:17 -0400
Message-id: <32189293481566511950@wsc.cz>
Subject: [PATCH 1/1] Char: Kconfig, mxser_new: remove experimental comment
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Tue, 29 May 2007 12:45:09 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kconfig, mxser_new: remove experimental comment

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 70591fd7231ee9767b813b052ff5b6123c8963b9
tree 0a686cee41b4f9f5e964b36a9001e3c0b03dc29d
parent 1a5e44385253ef9a193badf768f40543af6996ca
author Jiri Slaby <jirislaby@gmail.com> Mon, 28 May 2007 23:14:05 +0200
committer Jiri Slaby <jirislaby@gmail.com> Mon, 28 May 2007 23:14:05 +0200

 drivers/char/Kconfig |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 5f4ee3a..c4c7588 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -213,8 +213,6 @@ config MOXA_SMARTIO_NEW
 	  This is upgraded (1.9.1) driver from original Moxa drivers with
 	  changes finally resulting in PCI probing.
 
-	  Use at your own risk.
-
 	  This driver can also be built as a module. The module will be called
 	  mxser_new. If you want to do that, say M here.
 
