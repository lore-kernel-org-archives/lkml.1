Return-Path: <linux-kernel-owner+w=401wt.eu-S1753893AbYJZMCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbYJZMCz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 08:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbYJZMCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 08:02:46 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:33636 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbYJZMCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 08:02:46 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Subrata Modak <subrata@linux.vnet.ibm.com>
Subject: [PATCH] MAINTAINERS: add LTP info to the list
Date: Sun, 26 Oct 2008 08:02:42 -0400
Message-Id: <1225022562-5180-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Subrata Modak <subrata@linux.vnet.ibm.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 MAINTAINERS |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 16202c8..ce521d2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2701,6 +2701,16 @@ M:	matthew@wil.cx
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 
+LTP (Linux Test Project)
+P:	Subrata Modak
+M:	subrata@linux.vnet.ibm.com
+P:	Mike Frysinger
+M:	vapier@gentoo.org
+L:	ltp-list@lists.sourceforge.net (subscribers-only)
+W:	http://ltp.sourceforge.net/
+T:	git kernel.org/pub/scm/linux/kernel/git/galak/ltp.git
+S:	Maintained
+
 M32R ARCHITECTURE
 P:	Hirokazu Takata
 M:	takata@linux-m32r.org
-- 
1.6.0.2

