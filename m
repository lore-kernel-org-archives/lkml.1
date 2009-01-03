Return-Path: <linux-kernel-owner+w=401wt.eu-S932119AbZACHwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119AbZACHwX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 02:52:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbZACHwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 02:52:15 -0500
Received: from vps1.tull.net ([66.180.172.116]:49103 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750759AbZACHwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 02:52:14 -0500
From: Nick Andrew <nick@nick-andrew.net>
Subject: [TRIVIAL PATCH 02/11] Fix misspelling of "firmware" in atmel.c
To: Trivial Kernel Patches <trivial@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 03 Jan 2009 18:51:33 +1100
Message-ID: <20090103075123.27466.13653.stgit@marcab.local>
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

Fix misspelling of "firmware" in atmel.c

It's spelled "firmware".

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 drivers/net/wireless/atmel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/net/wireless/atmel.c b/drivers/net/wireless/atmel.c
index ecb02bd..d9058b8 100644
--- a/drivers/net/wireless/atmel.c
+++ b/drivers/net/wireless/atmel.c
@@ -3839,7 +3839,7 @@ static int reset_atmel_card(struct net_device *dev)
 	   This routine is also responsible for initialising some
 	   hardware-specific fields in the atmel_private structure,
 	   including a copy of the firmware's hostinfo stucture
-	   which is the route into the rest of the firmare datastructures. */
+	   which is the route into the rest of the firmware datastructures. */
 
 	struct atmel_private *priv = netdev_priv(dev);
 	u8 configuration;

