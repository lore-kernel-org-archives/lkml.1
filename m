Return-Path: <linux-kernel-owner+w=401wt.eu-S935458AbZJOUQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935458AbZJOUQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 16:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935406AbZJOUQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 16:16:28 -0400
Received: from 139.254.232.72.static.reverse.ltdomains.com ([72.232.254.139]:41002
	"EHLO liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932679AbZJOUQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 16:16:27 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: trivial@kernel.org
Cc: Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Bob Copeland <me@bobcopeland.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH 5/8] trivial: fix typo s/assocate/associate/ in comment
Date: Thu, 15 Oct 2009 17:15:38 -0300
Message-Id: <1255637738-6069-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/net/wireless/ath/ath5k/base.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index b14ba07..b73e7d3 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -192,7 +192,7 @@ struct ath5k_softc {
 	struct ath5k_txq	*cabq;		/* content after beacon */
 
 	int 			power_level;	/* Requested tx power in dbm */
-	bool			assoc;		/* assocate state */
+	bool			assoc;		/* associate state */
 	bool			enable_beacon;	/* true if beacons are on */
 };
 
-- 
1.6.3.3

