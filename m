Return-Path: <linux-kernel-owner+w=401wt.eu-S1753622AbZIXSn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622AbZIXSn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 14:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753906AbZIXSnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 14:43:50 -0400
Received: from mail.perches.com ([173.55.12.10]:1159 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937AbZIXSl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 14:41:56 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 05/11] MAINTAINERS: Use tab not spaces after field types
Date: Thu, 24 Sep 2009 11:41:53 -0700
Message-Id: <3961e5d1dad00d2b0eeb0788fc3d04e320b685e2.1253817463.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1253817463.git.joe@perches.com>
References: <cover.1253817463.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5562463..0aa0776 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4546,20 +4546,20 @@ S:	Maintained
 F:	drivers/mmc/host/sdricoh_cs.c
 
 SECURE DIGITAL HOST CONTROLLER INTERFACE (SDHCI) DRIVER
-S:     Orphan
-L:     linux-mmc@vger.kernel.org
-F:     drivers/mmc/host/sdhci.*
+S:	Orphan
+L:	linux-mmc@vger.kernel.org
+F:	drivers/mmc/host/sdhci.*
 
 SECURE DIGITAL HOST CONTROLLER INTERFACE, OPEN FIRMWARE BINDINGS (SDHCI-OF)
 M:	Anton Vorontsov <avorontsov@ru.mvista.com>
 L:	linuxppc-dev@ozlabs.org
-L:     linux-mmc@vger.kernel.org
+L:	linux-mmc@vger.kernel.org
 S:	Maintained
-F:     drivers/mmc/host/sdhci-of.*
+F:	drivers/mmc/host/sdhci-of.*
 
 SECURE DIGITAL HOST CONTROLLER INTERFACE (SDHCI) SAMSUNG DRIVER
 M:	Ben Dooks <ben-linux@fluff.org>
-L:     linux-mmc@vger.kernel.org
+L:	linux-mmc@vger.kernel.org
 S:	Maintained
 F:	drivers/mmc/host/sdhci-s3c.c
 
-- 
1.6.3.1.10.g659a0.dirty

