Return-Path: <linux-kernel-owner+w=401wt.eu-S932168AbZALWvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168AbZALWvu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:51:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbZALWgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:36:01 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44938 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611AbZALWgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:36:00 -0500
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>,
       trivial@kernel.org
Date: Mon, 12 Jan 2009 23:35:47 +0100
Message-Id: <1231799750-21060-2-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <alpine.LNX.1.10.0901122314361.5377@jikos.suse.cz>
References: <alpine.LNX.1.10.0901122314361.5377@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ukl@pengutronix.de
Subject: [PATCH] fix typo "kernal" -> "kernel"
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
Cc: trivial@kernel.org
---
 fs/proc/nommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/proc/nommu.c b/fs/proc/nommu.c
index 3f87d26..2c871f2 100644
--- a/fs/proc/nommu.c
+++ b/fs/proc/nommu.c
@@ -76,7 +76,7 @@ int nommu_vma_show(struct seq_file *m, struct vm_area_struct *vma)
 
 /*
  * display a list of all the VMAs the kernel knows about
- * - nommu kernals have a single flat list
+ * - nommu kernels have a single flat list
  */
 static int nommu_vma_list_show(struct seq_file *m, void *v)
 {
-- 
1.5.6.5

