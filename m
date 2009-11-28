Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918AbZK1MG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbZK1MG1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 07:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbZK1MG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 07:06:27 -0500
Received: from smtp-OUT05A.alice.it ([85.33.3.5]:1786 "EHLO
	smtp-OUT05A.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbZK1MG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 07:06:26 -0500
X-Greylist: delayed 612 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Nov 2009 07:06:26 EST
From: Antonio Ospite <ospite@studenti.unina.it>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Antonio Ospite <ospite@studenti.unina.it>, linux-kernel@vger.kernel.org,
       trivial@kernel.org, Riku Voipio <riku.voipio@movial.com>
Subject: [TRIVIAL PATCH] leds-pca9532.h: indent with tabs, not spaces.
Date: Sat, 28 Nov 2009 12:55:51 +0100
Message-Id: <1259409351-7034-1-git-send-email-ospite@studenti.unina.it>
X-Mailer: git-send-email 1.6.5.3
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+ ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
X-OriginalArrivalTime: 28 Nov 2009 11:56:17.0137 (UTC) FILETIME=[CAC12E10:01CA7021]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 include/linux/leds-pca9532.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/leds-pca9532.h b/include/linux/leds-pca9532.h
index 96eea90..f158eb1 100644
--- a/include/linux/leds-pca9532.h
+++ b/include/linux/leds-pca9532.h
@@ -32,7 +32,7 @@ struct pca9532_led {
 	struct i2c_client *client;
 	char *name;
 	struct led_classdev ldev;
-       struct work_struct work;
+	struct work_struct work;
 	enum pca9532_type type;
 	enum pca9532_state state;
 };
-- 
1.6.5.3

