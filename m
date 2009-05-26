Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbZEZJQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbZEZJQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 05:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754792AbZEZJP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 05:15:59 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37416 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754703AbZEZJP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 05:15:58 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 4/7] MAINTAINERS: drop (subscribers-only) markings on Blackfin lists
Date: Tue, 26 May 2009 05:15:53 -0400
Message-Id: <1243329356-12644-5-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1243329356-12644-1-git-send-email-vapier@gentoo.org>
References: <1243329356-12644-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All of the Blackfin lists are transparently moderated for non-subscribers.
i.e. there are no annoying notices and people get whitelisted after first
their posting.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 MAINTAINERS |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7dd3475..5ee166e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1142,7 +1142,7 @@ F:	arch/blackfin/
 BLACKFIN EMAC DRIVER
 P:	Michael Hennerich
 M:	michael.hennerich@analog.com
-L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
+L:	uclinux-dist-devel@blackfin.uclinux.org
 W:	http://blackfin.uclinux.org
 S:	Supported
 F:	drivers/net/bfin_mac.*
@@ -1150,7 +1150,7 @@ F:	drivers/net/bfin_mac.*
 BLACKFIN RTC DRIVER
 P:	Mike Frysinger
 M:	vapier.adi@gmail.com
-L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
+L:	uclinux-dist-devel@blackfin.uclinux.org
 W:	http://blackfin.uclinux.org
 S:	Supported
 F:	drivers/rtc/rtc-bfin.c
@@ -1158,7 +1158,7 @@ F:	drivers/rtc/rtc-bfin.c
 BLACKFIN SERIAL DRIVER
 P:	Sonic Zhang
 M:	sonic.zhang@analog.com
-L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
+L:	uclinux-dist-devel@blackfin.uclinux.org
 W:	http://blackfin.uclinux.org
 S:	Supported
 F:	drivers/serial/bfin_5xx.c
@@ -1166,7 +1166,7 @@ F:	drivers/serial/bfin_5xx.c
 BLACKFIN WATCHDOG DRIVER
 P:	Mike Frysinger
 M:	vapier.adi@gmail.com
-L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
+L:	uclinux-dist-devel@blackfin.uclinux.org
 W:	http://blackfin.uclinux.org
 S:	Supported
 F:	drivers/watchdog/bfin_wdt.c
@@ -1174,7 +1174,7 @@ F:	drivers/watchdog/bfin_wdt.c
 BLACKFIN I2C TWI DRIVER
 P:	Sonic Zhang
 M:	sonic.zhang@analog.com
-L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
+L:	uclinux-dist-devel@blackfin.uclinux.org
 W:	http://blackfin.uclinux.org/
 S:	Supported
 F:	drivers/i2c/busses/i2c-bfin-twi.c
-- 
1.6.3.1

