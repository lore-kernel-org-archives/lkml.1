Return-Path: <linux-kernel-owner+w=401wt.eu-S1760618AbYDKUic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760618AbYDKUic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 16:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760186AbYDKUhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 16:37:31 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59853 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759485AbYDKUh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 16:37:28 -0400
X-Sasl-enc: MEXVkqRXCMsiy3EEquwl0Vfk//EB/Yj5mgIxDJsVAYJR 1207946247
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Ivo van Doorn <IvDoorn@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH 2/8] rfkill: fix minor typo in kernel doc
Date: Fri, 11 Apr 2008 17:37:18 -0300
Message-Id: <1207946244-14525-3-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.5.4.4
In-Reply-To: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a minor typo in an exported function documentation

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
---
 net/rfkill/rfkill.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index 140a0a8..1601e50 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -412,7 +412,7 @@ int rfkill_register(struct rfkill *rfkill)
 EXPORT_SYMBOL(rfkill_register);
 
 /**
- * rfkill_unregister - Uegister a rfkill structure.
+ * rfkill_unregister - Unregister a rfkill structure.
  * @rfkill: rfkill structure to be unregistered
  *
  * This function should be called by the network driver during device
-- 
1.5.4.4

