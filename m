Return-Path: <linux-kernel-owner+w=401wt.eu-S1759741AbZF1QjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759741AbZF1QjP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756971AbZF1Q2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:28:21 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1166 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757309AbZF1Q2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:28:09 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 49/62] drivers/video/cfbcopyarea.c: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:54 -0700
Message-Id: <9871438c12a0708df389da1a13ddd440fb7aad29.1246173683.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/video/cfbcopyarea.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/cfbcopyarea.c b/drivers/video/cfbcopyarea.c
index df03f37..79e5f40 100644
--- a/drivers/video/cfbcopyarea.c
+++ b/drivers/video/cfbcopyarea.c
@@ -114,7 +114,7 @@ bitcpy(struct fb_info *p, unsigned long __iomem *dst, int dst_idx,
 				d0 >>= right;
 			} else if (src_idx+n <= bits) {
 				// Single source word
-				d0 <<= left;;
+				d0 <<= left;
 			} else {
 				// 2 source words
 				d1 = FB_READL(src + 1);
-- 
1.6.3.1.10.g659a0.dirty

