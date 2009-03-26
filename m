Return-Path: <linux-kernel-owner+w=401wt.eu-S1757337AbZCZNcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbZCZNcu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 09:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbZCZNcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 09:32:42 -0400
Received: from mx1.emlix.com ([193.175.82.87]:57190 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbZCZNcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 09:32:41 -0400
From: =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [patch 2/4] xtensa: define irq number for I2S on s6105
Date: Thu, 26 Mar 2009 14:33:46 +0100
Message-Id: <1238074428-24666-2-git-send-email-dg@emlix.com>
In-Reply-To: <1238074428-24666-1-git-send-email-dg@emlix.com>
References: <1238074428-24666-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: emlix gmbh, Goettingen, Germany"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 arch/xtensa/platforms/s6105/include/platform/irq.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/xtensa/platforms/s6105/include/platform/irq.h b/arch/xtensa/platforms/s6105/include/platform/irq.h
index 3d5d4d2..84c972f 100644
--- a/arch/xtensa/platforms/s6105/include/platform/irq.h
+++ b/arch/xtensa/platforms/s6105/include/platform/irq.h
@@ -6,6 +6,7 @@
 #define GMAC_INTNUM	5
 #define I2C_INTNUM	6
 #define ISEF_INTNUM	8
+#define I2S_INTNUM	10
 #define SPI_INTNUM	11
 
 #endif
-- 
1.6.2.107.ge47ee

