Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbZHKOTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbZHKOTK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 10:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694AbZHKOTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 10:19:09 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:56437 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbZHKOTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 10:19:08 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: trivial@kernel.org
Cc: johannes@sipsolutions.net, davem@davemloft.net, linville@tuxdriver.com,
       lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH] trivial: remove duplicate "different" from comment
Date: Tue, 11 Aug 2009 11:18:42 -0300
Message-Id: <1250000322-19354-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 net/wireless/reg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index fc7a484..f256dff 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1424,7 +1424,7 @@ static int ignore_request(struct wiphy *wiphy,
 			if (last_wiphy != wiphy) {
 				/*
 				 * Two cards with two APs claiming different
-				 * different Country IE alpha2s. We could
+				 * Country IE alpha2s. We could
 				 * intersect them, but that seems unlikely
 				 * to be correct. Reject second one for now.
 				 */
-- 
1.6.3.3

