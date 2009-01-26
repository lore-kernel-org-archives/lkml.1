Return-Path: <linux-kernel-owner+w=401wt.eu-S1752146AbZAZCC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbZAZCC7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 21:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbZAZCCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 21:02:42 -0500
Received: from vps1.tull.net ([66.180.172.116]:50678 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752905AbZAZCCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 21:02:41 -0500
From: Nick Andrew <nick@nick-andrew.net>
Subject: [TRIVIAL PATCH 06/20] Fix misspelling of firmware in tg3.c
To: Trivial Kernel Patches <trivial@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 26 Jan 2009 13:02:34 +1100
Message-ID: <20090126020234.15168.68824.stgit@marcab.local.tull.net>
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

Fix misspelling of firmware in tg3.c

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 drivers/net/tg3.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
index 5e2dbae..96ede2a 100644
--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -11130,7 +11130,7 @@ static int __devinit tg3_phy_probe(struct tg3 *tp)
 		return tg3_phy_init(tp);
 
 	/* Reading the PHY ID register can conflict with ASF
-	 * firwmare access to the PHY hardware.
+	 * firmware access to the PHY hardware.
 	 */
 	err = 0;
 	if ((tp->tg3_flags & TG3_FLAG_ENABLE_ASF) ||

