Return-Path: <linux-kernel-owner+w=401wt.eu-S935865AbXEUTzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935865AbXEUTzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934083AbXEUT34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:29:56 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52705 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934151AbXEUT3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:29:53 -0400
Message-Id: <20070521191722.829786000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:16:39 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Michael Chan" <mchan@broadcom.com>,
       David S Miller <davem@davemloft.net>
Subject: [patch 27/69] BNX2: Update version and reldate.
Content-Disposition: inline; filename=bnx2-update-version-and-reldate.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From:  <mchan@broadcom.com>

Update version to 1.5.8.1.

Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

---
 drivers/net/bnx2.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.21.1.orig/drivers/net/bnx2.c
+++ linux-2.6.21.1/drivers/net/bnx2.c
@@ -54,8 +54,8 @@
 
 #define DRV_MODULE_NAME		"bnx2"
 #define PFX DRV_MODULE_NAME	": "
-#define DRV_MODULE_VERSION	"1.5.8"
-#define DRV_MODULE_RELDATE	"April 24, 2007"
+#define DRV_MODULE_VERSION	"1.5.8.1"
+#define DRV_MODULE_RELDATE	"May 7, 2007"
 
 #define RUN_AT(x) (jiffies + (x))
 

-- 
