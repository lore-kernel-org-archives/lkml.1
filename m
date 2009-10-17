Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbZJQXra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbZJQXra (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 19:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbZJQXrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 19:47:01 -0400
Received: from mail.perches.com ([173.55.12.10]:2245 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539AbZJQXrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 19:47:00 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] MAINTAINERS: BROCADE BFA - Use single line M: and tabs
Date: Sat, 17 Oct 2009 16:47:02 -0700
Message-Id: <77c4661fa9d1ee0aef5fbff233c1d1946e7578de.1255822797.git.joe@perches.com>
X-Mailer: git-send-email 1.6.5.rc3.dirty
In-Reply-To: <cover.1255822797.git.joe@perches.com>
References: <cover.1255822797.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Integrate P:/M: to single M:
Use tab for spacing

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0b70ca9..7f3dca7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1236,11 +1236,10 @@ S:	Supported
 F:	drivers/net/tg3.*
 
 BROCADE BFA FC SCSI DRIVER
-P:      Jing Huang
-M:      huangj@brocade.com
-L:      linux-scsi@vger.kernel.org
-S:      Supported
-F:      drivers/scsi/bfa/
+M:	Jing Huang <huangj@brocade.com>
+L:	linux-scsi@vger.kernel.org
+S:	Supported
+F:	drivers/scsi/bfa/
 
 BSG (block layer generic sg v4 driver)
 M:	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
-- 
1.6.5.rc3.dirty

