Return-Path: <linux-kernel-owner+w=401wt.eu-S1759658AbZACHvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759658AbZACHvT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 02:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbZACHvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 02:51:08 -0500
Received: from vps1.tull.net ([66.180.172.116]:49100 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750759AbZACHvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 02:51:06 -0500
From: Nick Andrew <nick@nick-andrew.net>
Subject: [TRIVIAL PATCH 01/11] Fix misspelled firmware in Kconfig
To: Trivial Kernel Patches <trivial@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 03 Jan 2009 18:50:34 +1100
Message-ID: <20090103075024.27466.46301.stgit@marcab.local>
In-Reply-To: <20090103074923.27466.7287.stgit@marcab.local>
References: <20090103074923.27466.7287.stgit@marcab.local>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix misspelled firmware in Kconfig

It's spelled "firmware".

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 drivers/base/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index d8e8c49..8f006f9 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -54,7 +54,7 @@ config FIRMWARE_IN_KERNEL
 	  such firmware, and do not wish to use an initrd.
 
 	  This single option controls the inclusion of firmware for
-	  every driver which uses request_firmare() and ships its
+	  every driver which uses request_firmware() and ships its
 	  firmware in the kernel source tree, to avoid a proliferation
 	  of 'Include firmware for xxx device' options.
 

