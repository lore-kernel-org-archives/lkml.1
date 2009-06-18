Return-Path: <linux-kernel-owner+w=401wt.eu-S1759999AbZFRSI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759999AbZFRSI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 14:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757280AbZFRSIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 14:08:12 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1516 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076AbZFRSIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 14:08:06 -0400
From: Joe Perches <joe@perches.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Sergey Lapin <slapin@ossfans.org>,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       linux-zigbee-devel@lists.sourceforge.net
Subject: [PATCH 4/5] MAINTAINERS: ieee802154 fix pattern typo
Date: Thu, 18 Jun 2009 11:08:04 -0700
Message-Id: <e3bb2ff1b37b724181e958a1ffdb1f5bc1d0a5e5.1245345515.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1245345515.git.joe@perches.com>
References: <cover.1245345515.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f4175c5..2375de3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2850,7 +2850,7 @@ W:	http://apps.sourceforge.net/trac/linux-zigbee
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lumag/lowpan.git
 S:	Maintained
 F:	net/ieee802154/
-F:	drivers/ieee801254/
+F:	drivers/ieee802154/
 
 INTEGRITY MEASUREMENT ARCHITECTURE (IMA)
 P:	Mimi Zohar
-- 
1.6.3.1.10.g659a0.dirty

