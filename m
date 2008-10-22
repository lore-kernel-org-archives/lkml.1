Return-Path: <linux-kernel-owner+w=401wt.eu-S1758201AbYJVRg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201AbYJVRg7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757508AbYJVRdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:33:17 -0400
Received: from kroah.org ([198.145.64.141]:53032 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755767AbYJVRdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:33:09 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Huang Weiyi <weiyi.huang@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 11/42] Staging: wlan-ng: prism2: remove duplicated #include
Date: Wed, 22 Oct 2008 10:28:52 -0700
Message-Id: <1224696563-5170-11-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081022172203.GA4000@kroah.com>
References: <20081022172203.GA4000@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Weiyi <weiyi.huang@gmail.com>

Removed duplicated #include "wlan_compat.h" in
drivers/staging/wlan-ng/prism2mib.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/wlan-ng/prism2mib.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2mib.c b/drivers/staging/wlan-ng/prism2mib.c
index 268fd9b..eac06f7 100644
--- a/drivers/staging/wlan-ng/prism2mib.c
+++ b/drivers/staging/wlan-ng/prism2mib.c
@@ -90,8 +90,6 @@
 #include <linux/usb.h>
 //#endif
 
-#include "wlan_compat.h"
-
 /*================================================================*/
 /* Project Includes */
 
-- 
1.6.0.2

