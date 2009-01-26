Return-Path: <linux-kernel-owner+w=401wt.eu-S1752988AbZAZCF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbZAZCF7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 21:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbZAZCFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 21:05:50 -0500
Received: from vps1.tull.net ([66.180.172.116]:36450 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751004AbZAZCFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 21:05:49 -0500
From: Nick Andrew <nick@nick-andrew.net>
Subject: [TRIVIAL PATCH 12/20] Fix misspelling of firmware in ChangeLog.history
To: Trivial Kernel Patches <trivial@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 26 Jan 2009 13:05:42 +1100
Message-ID: <20090126020542.15168.2213.stgit@marcab.local.tull.net>
In-Reply-To: <20090126015921.15168.97302.stgit@marcab.local.tull.net>
References: <20090126015921.15168.97302.stgit@marcab.local.tull.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix misspelling of firmware in ChangeLog.history

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 drivers/usb/serial/ChangeLog.history |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/usb/serial/ChangeLog.history b/drivers/usb/serial/ChangeLog.history
index c1b2799..f13fd48 100644
--- a/drivers/usb/serial/ChangeLog.history
+++ b/drivers/usb/serial/ChangeLog.history
@@ -715,7 +715,7 @@ io_edgeport.c Change Log comments:
 
  0.2 (01/30/2000) greg kroah-hartman
 	Milestone 1 release.
-	Device is found by USB subsystem, enumerated, fimware is downloaded
+	Device is found by USB subsystem, enumerated, firmware is downloaded
 	and the descriptors are printed to the debug log, config is set, and
 	green light starts to blink. Open port works, and data can be sent
 	and received at the default settings of the UART. Loopback connector

