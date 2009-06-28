Return-Path: <linux-kernel-owner+w=401wt.eu-S1752677AbZF1Q3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbZF1Q3i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755809AbZF1Q1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:27:23 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1087 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717AbZF1Q1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:27:19 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [PATCH 09/62] arch/sparc/kernel/irq_64.c: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:14 -0700
Message-Id: <414b714740846e13e355f33c11595eb9e7cb14b7.1246173680.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/sparc/kernel/irq_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/sparc/kernel/irq_64.c b/arch/sparc/kernel/irq_64.c
index f0ee790..ea183b9 100644
--- a/arch/sparc/kernel/irq_64.c
+++ b/arch/sparc/kernel/irq_64.c
@@ -229,7 +229,7 @@ static unsigned int sun4u_compute_tid(unsigned long imap, unsigned long cpuid)
 				tid = ((a << IMAP_AID_SHIFT) |
 				       (n << IMAP_NID_SHIFT));
 				tid &= (IMAP_AID_SAFARI |
-					IMAP_NID_SAFARI);;
+					IMAP_NID_SAFARI);
 			}
 		} else {
 			tid = cpuid << IMAP_TID_SHIFT;
-- 
1.6.3.1.10.g659a0.dirty

