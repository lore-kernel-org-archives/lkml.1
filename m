Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781AbZF1Q3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbZF1Q3K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755295AbZF1Q1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:27:16 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1075 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257AbZF1Q1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:27:11 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
Subject: [PATCH 04/62] arch/mips/kernel/vpe.c: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:09 -0700
Message-Id: <012172308c2e751761b89ec3c38fbc64b8137495.1246173680.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/mips/kernel/vpe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/kernel/vpe.c b/arch/mips/kernel/vpe.c
index 3ca5f42..07b9ec2 100644
--- a/arch/mips/kernel/vpe.c
+++ b/arch/mips/kernel/vpe.c
@@ -1387,7 +1387,7 @@ static ssize_t store_ntcs(struct device *dev, struct device_attribute *attr,
 	return len;
 
 out_einval:
-	return -EINVAL;;
+	return -EINVAL;
 }
 
 static struct device_attribute vpe_class_attributes[] = {
-- 
1.6.3.1.10.g659a0.dirty

