Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855Ab0AQVRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab0AQVRA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 16:17:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754325Ab0AQVQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 16:16:59 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:45728 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab0AQVQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 16:16:59 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: trivial@kernel.org
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       WANG Cong <amwang@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] trivial: typo at ksysfs.c s/boo/boot/
Date: Sun, 17 Jan 2010 19:14:26 -0200
Message-Id: <1263762867-9090-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 kernel/ksysfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index 3feaf5a..ac08efc 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -33,7 +33,7 @@ static ssize_t uevent_seqnum_show(struct kobject *kobj,
 }
 KERNEL_ATTR_RO(uevent_seqnum);
 
-/* uevent helper program, used during early boo */
+/* uevent helper program, used during early boot */
 static ssize_t uevent_helper_show(struct kobject *kobj,
 				  struct kobj_attribute *attr, char *buf)
 {
-- 
1.6.6

