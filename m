Return-Path: <linux-kernel-owner+w=401wt.eu-S1760383AbZDLKsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760383AbZDLKsg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 06:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760043AbZDLKrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 06:47:36 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:49841 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759549AbZDLKre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 06:47:34 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: [PATCH 3/4] balance parentheses in dvb stv0900_priv.h code
Date: Sun, 12 Apr 2009 12:47:30 +0200
Message-Id: <1239533251-31276-4-git-send-email-m.kozlowski@tuxland.pl>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1239533251-31276-1-git-send-email-m.kozlowski@tuxland.pl>
References: <1239533251-31276-1-git-send-email-m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
---
 drivers/media/dvb/frontends/stv0900_priv.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/frontends/stv0900_priv.h b/drivers/media/dvb/frontends/stv0900_priv.h
index 762d5af..bbd0697 100644
--- a/drivers/media/dvb/frontends/stv0900_priv.h
+++ b/drivers/media/dvb/frontends/stv0900_priv.h
@@ -60,7 +60,7 @@
 		} \
 	} while (0)
 
-#define dmd_choose(a, b)	(demod = STV0900_DEMOD_2 ? b : a))
+#define dmd_choose(a, b)	(demod = STV0900_DEMOD_2 ? b : a)
 
 static int stvdebug;
 
-- 
1.5.6.3

