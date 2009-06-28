Return-Path: <linux-kernel-owner+w=401wt.eu-S1759646AbZF1Qix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759646AbZF1Qix (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757319AbZF1Q2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:28:20 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1165 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759AbZF1Q2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:28:09 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 48/62] drivers/uwb/i1480/i1480u-wlp/netdev.c: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:53 -0700
Message-Id: <7d34b5638438929d3185beaf2caada8025b526cc.1246173683.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/uwb/i1480/i1480u-wlp/netdev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/uwb/i1480/i1480u-wlp/netdev.c b/drivers/uwb/i1480/i1480u-wlp/netdev.c
index 7305553..b236e69 100644
--- a/drivers/uwb/i1480/i1480u-wlp/netdev.c
+++ b/drivers/uwb/i1480/i1480u-wlp/netdev.c
@@ -214,7 +214,7 @@ int i1480u_open(struct net_device *net_dev)
 
 	netif_wake_queue(net_dev);
 #ifdef i1480u_FLOW_CONTROL
-	result = usb_submit_urb(i1480u->notif_urb, GFP_KERNEL);;
+	result = usb_submit_urb(i1480u->notif_urb, GFP_KERNEL);
 	if (result < 0) {
 		dev_err(dev, "Can't submit notification URB: %d\n", result);
 		goto error_notif_urb_submit;
-- 
1.6.3.1.10.g659a0.dirty

