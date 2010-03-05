Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab0CEQ5L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 11:57:11 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:55205 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020Ab0CEQ5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 11:57:09 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org, trivial@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] MTD: drop +x perms on C source files
Date: Fri,  5 Mar 2010 12:00:20 -0500
Message-Id: <1267808420-27330-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 0 files changed, 0 insertions(+), 0 deletions(-)
 mode change 100755 => 100644 drivers/mtd/chips/cfi_util.c
 mode change 100755 => 100644 drivers/mtd/inftlcore.c

diff --git a/drivers/mtd/chips/cfi_util.c b/drivers/mtd/chips/cfi_util.c
old mode 100755
new mode 100644
diff --git a/drivers/mtd/inftlcore.c b/drivers/mtd/inftlcore.c
old mode 100755
new mode 100644
-- 
1.7.0

