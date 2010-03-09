Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab0CIObS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 09:31:18 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:59810 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753722Ab0CIObP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 09:31:15 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: add bfin_sdh driver
Date: Tue,  9 Mar 2010 09:34:32 -0500
Message-Id: <1268145272-11270-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 MAINTAINERS |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2533fc4..00aa72b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1222,6 +1222,13 @@ W:	http://blackfin.uclinux.org
 S:	Supported
 F:	drivers/rtc/rtc-bfin.c
 
+BLACKFIN SDH DRIVER
+M:	Cliff Cai <cliff.cai@analog.com>
+L:	uclinux-dist-devel@blackfin.uclinux.org
+W:	http://blackfin.uclinux.org
+S:	Supported
+F:	drivers/mmc/host/bfin_sdh.c
+
 BLACKFIN SERIAL DRIVER
 M:	Sonic Zhang <sonic.zhang@analog.com>
 L:	uclinux-dist-devel@blackfin.uclinux.org
-- 
1.7.0.2

