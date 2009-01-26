Return-Path: <linux-kernel-owner+w=401wt.eu-S1752852AbZAZCCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbZAZCCk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 21:02:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbZAZCCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 21:02:11 -0500
Received: from vps1.tull.net ([66.180.172.116]:50674 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752019AbZAZCCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 21:02:10 -0500
From: Nick Andrew <nick@nick-andrew.net>
Subject: [TRIVIAL PATCH 05/20] Fix misspelling of firmware in sb1250-mac.c
To: Trivial Kernel Patches <trivial@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 26 Jan 2009 13:02:02 +1100
Message-ID: <20090126020202.15168.9114.stgit@marcab.local.tull.net>
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

Fix misspelling of firmware in sb1250-mac.c

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 drivers/net/sb1250-mac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/net/sb1250-mac.c b/drivers/net/sb1250-mac.c
index 31e38fa..7fe82c5 100644
--- a/drivers/net/sb1250-mac.c
+++ b/drivers/net/sb1250-mac.c
@@ -2299,7 +2299,7 @@ static int sbmac_init(struct platform_device *pldev, long long base)
 	eaddr = sc->sbm_hwaddr;
 
 	/*
-	 * Read the ethernet address.  The firwmare left this programmed
+	 * Read the ethernet address.  The firmware left this programmed
 	 * for us in the ethernet address register for each mac.
 	 */
 

