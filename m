Return-Path: <linux-kernel-owner+w=401wt.eu-S1758239AbYJVRh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239AbYJVRh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756313AbYJVRdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:33:17 -0400
Received: from kroah.org ([198.145.64.141]:53036 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757308AbYJVRdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:33:11 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Huang Weiyi <weiyi.huang@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 12/42] staging: wlan-ng: prism2: remove more duplicated #include
Date: Wed, 22 Oct 2008 10:28:53 -0700
Message-Id: <1224696563-5170-12-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081022172203.GA4000@kroah.com>
References: <20081022172203.GA4000@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Weiyi <weiyi.huang@gmail.com>

Removed duplicated #include "version.h" in
drivers/staging/wlan-ng/p80211wep.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/wlan-ng/p80211wep.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/wlan-ng/p80211wep.c b/drivers/staging/wlan-ng/p80211wep.c
index 53fe298..11a50c7 100644
--- a/drivers/staging/wlan-ng/p80211wep.c
+++ b/drivers/staging/wlan-ng/p80211wep.c
@@ -64,7 +64,6 @@
 /*================================================================*/
 /* Project Includes */
 
-#include "version.h"
 #include "p80211hdr.h"
 #include "p80211types.h"
 #include "p80211msg.h"
-- 
1.6.0.2

