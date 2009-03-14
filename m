Return-Path: <linux-kernel-owner+w=401wt.eu-S1758853AbZCNVmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853AbZCNVmZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 17:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757420AbZCNVj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 17:39:57 -0400
Received: from pne-smtpout2-sn2.hy.skanova.net ([81.228.8.164]:57982 "EHLO
	pne-smtpout2-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757816AbZCNVj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 17:39:56 -0400
From: =?utf-8?q?Erik=20Andr=C3=A9n?= <erik.andren@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org,
       =?utf-8?q?Erik=20Andr=C3=A9n?= <erik.andren@gmail.com>
Subject: [PATCH 07/09] Checkpatch.pl: Fixup sta.h
Date: Sat, 14 Mar 2009 22:39:34 +0100
Message-Id: <1237066776-14697-8-git-send-email-erik.andren@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1237066776-14697-7-git-send-email-erik.andren@gmail.com>
References: <1>
 <1237066776-14697-1-git-send-email-erik.andren@gmail.com>
 <1237066776-14697-2-git-send-email-erik.andren@gmail.com>
 <1237066776-14697-3-git-send-email-erik.andren@gmail.com>
 <1237066776-14697-4-git-send-email-erik.andren@gmail.com>
 <1237066776-14697-5-git-send-email-erik.andren@gmail.com>
 <1237066776-14697-6-git-send-email-erik.andren@gmail.com>
 <1237066776-14697-7-git-send-email-erik.andren@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erik Andrén <erik.andren@gmail.com>
---
 drivers/staging/agnx/sta.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/agnx/sta.h b/drivers/staging/agnx/sta.h
index 58d0b12..94e2cf1 100644
--- a/drivers/staging/agnx/sta.h
+++ b/drivers/staging/agnx/sta.h
@@ -16,7 +16,7 @@ struct agnx_hash_cmd {
 #define PASS		0x00000001
 #define PASS_SHIFT	1
 	__be32 cmdlo;
-}__attribute__((__packed__));
+} __attribute__((__packed__));
 
 
 /*
-- 
1.6.0.4

