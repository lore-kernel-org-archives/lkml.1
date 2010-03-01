Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587Ab0CAPMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:12:54 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:46340 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab0CAPMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:12:52 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 04/26] w35und: Remove unused enum enum_PowerManagementMode
Date: Mon,  1 Mar 2010 17:04:06 +0200
Message-Id: <1267455868-4533-4-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
References: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/mac_structures.h |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/winbond/mac_structures.h b/drivers/staging/winbond/mac_structures.h
index 0d16196..8a9c5e8 100644
--- a/drivers/staging/winbond/mac_structures.h
+++ b/drivers/staging/winbond/mac_structures.h
@@ -116,13 +116,6 @@
 #define WLAN_MAX_PAIRWISE_CIPHER_SUITE_COUNT    ((u16) 6)
 #define WLAN_MAX_AUTH_KEY_MGT_SUITE_LIST_COUNT  ((u16) 2)
 
-//========================================================
-typedef enum enum_PowerManagementMode
-{
-    ACTIVE = 0,
-    POWER_SAVE
-} WB_PM_Mode, *PWB_PM_MODE;
-
 //===================================================================
 //  Reason Code (Table 18): indicate the reason of DisAssoc, DeAuthen
 //  length of ReasonCode is 2 Octs.
-- 
1.6.3.3

