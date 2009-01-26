Return-Path: <linux-kernel-owner+w=401wt.eu-S1753447AbZAZCD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbZAZCD4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 21:03:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751271AbZAZCDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 21:03:45 -0500
Received: from vps1.tull.net ([66.180.172.116]:50685 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751047AbZAZCDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 21:03:44 -0500
From: Nick Andrew <nick@nick-andrew.net>
Subject: [TRIVIAL PATCH 08/20] Fix misspelling of firmware in ipw2200.c
To: Trivial Kernel Patches <trivial@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 26 Jan 2009 13:03:37 +1100
Message-ID: <20090126020336.15168.50857.stgit@marcab.local.tull.net>
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

Fix misspelling of firmware in ipw2200.c

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 drivers/net/wireless/ipw2x00/ipw2200.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index 625f2cf..492f5b7 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -8827,7 +8827,7 @@ static int ipw_wx_set_mode(struct net_device *dev,
 #endif				/* CONFIG_IPW2200_MONITOR */
 
 	/* Free the existing firmware and reset the fw_loaded
-	 * flag so ipw_load() will bring in the new firmawre */
+	 * flag so ipw_load() will bring in the new firmware */
 	free_firmware();
 
 	priv->ieee->iw_mode = wrqu->mode;

