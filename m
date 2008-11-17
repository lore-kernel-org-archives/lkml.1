Return-Path: <linux-kernel-owner+w=401wt.eu-S1754269AbYKQSl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbYKQSl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 13:41:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbYKQSlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 13:41:07 -0500
Received: from mga09.intel.com ([134.134.136.24]:20419 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287AbYKQSlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 13:41:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,619,1220252400"; 
   d="scan'208";a="464100094"
From: Yi Zou <yi.zou@intel.com>
Subject: [PATCH 1/3] net: add ETH_P_FCOE for Fibre Channel over Ethernet (FCoE)
To: davem@davemloft.net
Cc: jeff@garzik.org, linux-netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Mon, 17 Nov 2008 10:30:31 -0800
Message-ID: <20081117183030.15776.51968.stgit@zychongqing.jf.intel.com>
In-Reply-To: <20081117182659.15776.58181.stgit@zychongqing.jf.intel.com>
References: <20081117182659.15776.58181.stgit@zychongqing.jf.intel.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yi Zou <yi.zou@intel.com>
---

 include/linux/if_ether.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/if_ether.h b/include/linux/if_ether.h
index 7f3c735..35f1110 100644
--- a/include/linux/if_ether.h
+++ b/include/linux/if_ether.h
@@ -78,6 +78,7 @@
 #define ETH_P_PAE	0x888E		/* Port Access Entity (IEEE 802.1X) */
 #define ETH_P_AOE	0x88A2		/* ATA over Ethernet		*/
 #define ETH_P_TIPC	0x88CA		/* TIPC 			*/
+#define ETH_P_FCOE	0x8906		/* Fibre Channel over Ethernet	*/
 #define ETH_P_EDSA	0xDADA		/* Ethertype DSA [ NOT AN OFFICIALLY REGISTERED ID ] */
 
 /*

