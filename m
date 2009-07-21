Return-Path: <linux-kernel-owner+w=401wt.eu-S1752105AbZGUMwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbZGUMwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 08:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbZGUMwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 08:52:49 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:40912 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbZGUMwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 08:52:46 -0400
From: Felipe Balbi <me@felipebalbi.com>
To: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Felipe Balbi <me@felipebalbi.com>
Subject: [PATCH 3/4] staging: cpc-usb: convert comment style in cpcusb.h
Date: Tue, 21 Jul 2009 15:52:25 +0300
Message-Id: <1248180746-18140-4-git-send-email-me@felipebalbi.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1248180746-18140-3-git-send-email-me@felipebalbi.com>
References: <1248180746-18140-1-git-send-email-me@felipebalbi.com>
 <1248180746-18140-2-git-send-email-me@felipebalbi.com>
 <1248180746-18140-3-git-send-email-me@felipebalbi.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Felipe Balbi <me@felipebalbi.com>
---
 drivers/staging/cpc-usb/cpcusb.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/cpc-usb/cpcusb.h b/drivers/staging/cpc-usb/cpcusb.h
index e5273dd..6bdf30b 100644
--- a/drivers/staging/cpc-usb/cpcusb.h
+++ b/drivers/staging/cpc-usb/cpcusb.h
@@ -75,7 +75,7 @@ typedef struct CPC_USB {
 #define CPC_DRIVER_VERSION "0.724"
 #define CPC_DRIVER_SERIAL  "not applicable"
 
-#define OBUF_SIZE 255		// 4096
+#define OBUF_SIZE 255		/* 4096 */
 
 /* read timeouts -- RD_NAK_TIMEOUT * RD_EXPIRE = Number of seconds */
 #define RD_NAK_TIMEOUT (10*HZ)	/* Default number of X seconds to wait */
-- 
1.6.4.rc1

