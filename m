Return-Path: <linux-kernel-owner+w=401wt.eu-S1753387AbZAZCDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbZAZCDZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 21:03:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbZAZCDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 21:03:14 -0500
Received: from vps1.tull.net ([66.180.172.116]:50682 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751190AbZAZCDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 21:03:13 -0500
From: Nick Andrew <nick@nick-andrew.net>
Subject: [TRIVIAL PATCH 07/20] Fix misspelling of firmware in ipw2100.c
To: Trivial Kernel Patches <trivial@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 26 Jan 2009 13:03:05 +1100
Message-ID: <20090126020305.15168.98542.stgit@marcab.local.tull.net>
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

Fix misspelling of firmware in ipw2100.c

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 drivers/net/wireless/ipw2x00/ipw2100.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
index 823c2bf..9170c23 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -2355,7 +2355,7 @@ static void ipw2100_corruption_detected(struct ipw2100_priv *priv, int i)
 		       i * sizeof(struct ipw2100_status));
 
 #ifdef IPW2100_DEBUG_C3
-	/* Halt the fimrware so we can get a good image */
+	/* Halt the firmware so we can get a good image */
 	write_register(priv->net_dev, IPW_REG_RESET_REG,
 		       IPW_AUX_HOST_RESET_REG_STOP_MASTER);
 	j = 5;

