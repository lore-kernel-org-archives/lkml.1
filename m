Return-Path: <linux-kernel-owner+w=401wt.eu-S1758439AbZGGOhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758439AbZGGOhw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758588AbZGGOfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:35:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:42746 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758568AbZGGOfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:35:51 -0400
Subject: [PATCH 15/22] trivial: fix typo "test test"
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: trivial <trivial@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1246975428.3613.10.camel@ht.satnam>
References: <1246975428.3613.10.camel@ht.satnam>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 19:51:20 +0530
Message-Id: <1246976480.3613.32.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Replaced "test test" with "test"

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/net/skfp/fplustm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/skfp/fplustm.c b/drivers/net/skfp/fplustm.c
index 6028bbb..f6ebed0 100644
--- a/drivers/net/skfp/fplustm.c
+++ b/drivers/net/skfp/fplustm.c
@@ -1321,7 +1321,7 @@ void mac_set_rx_mode(struct s_smc *smc, int mode)
 	o Connect a UPPS ISA or EISA station to the network.
 	o Give the FORMAC of UPPS station the command to send
 	  restricted tokens until the ring becomes instable.
-	o Now connect your test test client.
+	o Now connect your test client.
 	o The restricted token monitor should detect the restricted token,
 	  and your break point will be reached.
 	o You can ovserve how the station will clean the ring.
-- 
1.6.0.6



