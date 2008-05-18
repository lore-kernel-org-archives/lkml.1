Return-Path: <linux-kernel-owner+w=401wt.eu-S1761563AbYERSzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761563AbYERSzJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758851AbYERSsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:48:19 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:60949 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760570AbYERSsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:48:13 -0400
X-Sasl-enc: NeWlJ/vepwKxuLKHlGdJaiKKeRl/FmHfKhJTsavd4/J4 1211136492
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: Ivo van Doorn <IvDoorn@gmail.com>, Thomas Renninger <trenn@suse.de>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "John W. Linville" <linville@tuxdriver.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH 05/15] rfkill: fix minor typo in kernel doc
Date: Sun, 18 May 2008 15:47:55 -0300
Message-Id: <1211136485-19878-6-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br>
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
index 4e10a95..f95081a 100644
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
1.5.5.1

