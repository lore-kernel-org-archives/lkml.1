Return-Path: <linux-kernel-owner+w=401wt.eu-S1752094AbZAZCIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094AbZAZCIJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 21:08:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbZAZCHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 21:07:25 -0500
Received: from vps1.tull.net ([66.180.172.116]:36465 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751304AbZAZCHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 21:07:24 -0500
From: Nick Andrew <nick@nick-andrew.net>
Subject: [TRIVIAL PATCH 15/20] Fix misspelling of firmware in pss.c
To: Trivial Kernel Patches <trivial@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 26 Jan 2009 13:07:16 +1100
Message-ID: <20090126020716.15168.80328.stgit@marcab.local.tull.net>
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

Fix misspelling of firmware in pss.c

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 sound/oss/pss.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/sound/oss/pss.c b/sound/oss/pss.c
index 16ed069..902b39e 100644
--- a/sound/oss/pss.c
+++ b/sound/oss/pss.c
@@ -46,7 +46,7 @@
  *          load the driver as it did in previous versions.
  * 04-07-1999: Anthony Barbachan <barbcode@xmen.cis.fordham.edu>
  *          Added module parameter pss_firmware to allow the user to tell 
- *          the driver where the fireware file is located.  The default 
+ *          the driver where the firmware file is located.  The default 
  *          setting is the previous hardcoded setting "/etc/sound/pss_synth".
  * 00-03-03: Christoph Hellwig <chhellwig@infradead.org>
  *	    Adapted to module_init/module_exit

