Return-Path: <linux-kernel-owner+w=401wt.eu-S1755605AbZF1Q2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605AbZF1Q2v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755694AbZF1Q1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:27:15 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1072 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663AbZF1Q1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:27:10 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Greg Ungerer <gerg@uclinux.org>
Subject: [PATCH 03/62] arch/m68knommu/kernel/time.c: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:08 -0700
Message-Id: <fde8f173810c514e9a97bd1ece829d7a02d4bb41.1246173680.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/m68knommu/kernel/time.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/m68knommu/kernel/time.c b/arch/m68knommu/kernel/time.c
index d182b2f..c2aa717 100644
--- a/arch/m68knommu/kernel/time.c
+++ b/arch/m68knommu/kernel/time.c
@@ -69,7 +69,7 @@ static unsigned long read_rtc_mmss(void)
 	if ((year += 1900) < 1970)
 		year += 100;
 
-	return  mktime(year, mon, day, hour, min, sec);;
+	return  mktime(year, mon, day, hour, min, sec);
 }
 
 unsigned long read_persistent_clock(void)
-- 
1.6.3.1.10.g659a0.dirty

