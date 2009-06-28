Return-Path: <linux-kernel-owner+w=401wt.eu-S1760514AbZF1Qn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760514AbZF1Qn1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754778AbZF1Q2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:28:46 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1194 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbZF1Q2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:28:24 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 61/62] net/wireless/wext-compat.c: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:27:06 -0700
Message-Id: <4778c827bdc892c3f3d341e29fcdb2f6af5bec0e.1246173683.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/wireless/wext-compat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index d030c53..2e33fe5 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -794,7 +794,7 @@ int cfg80211_wext_siwtxpower(struct net_device *dev,
 		return 0;
 	}
 
-	return rdev->ops->set_tx_power(wdev->wiphy, type, dbm);;
+	return rdev->ops->set_tx_power(wdev->wiphy, type, dbm);
 }
 EXPORT_SYMBOL_GPL(cfg80211_wext_siwtxpower);
 
-- 
1.6.3.1.10.g659a0.dirty

