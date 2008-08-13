Return-Path: <linux-kernel-owner+w=401wt.eu-S1753423AbYHMIkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbYHMIkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbYHMIjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:39:21 -0400
Received: from smtp.nokia.com ([192.100.122.230]:37088 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbYHMIjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:39:20 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Zoltan Sogor <weth@inf.u-szeged.hu>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH] Documentation: fix typo in ubifs.txt
Date: Wed, 13 Aug 2008 13:17:30 +0300
Message-Id: <1218622675-28853-2-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
References: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 13 Aug 2008 08:39:03.0112 (UTC) FILETIME=[0A264480:01C8FD20]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Siewior <bigeasy@linutronix.de>

Signed-off-by: Sebastian Siewior <bigeasy@linutronix.de>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 Documentation/filesystems/ubifs.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/filesystems/ubifs.txt b/Documentation/filesystems/ubifs.txt
index 540e9e7..6a0d70a 100644
--- a/Documentation/filesystems/ubifs.txt
+++ b/Documentation/filesystems/ubifs.txt
@@ -57,7 +57,7 @@ Similarly to JFFS2, UBIFS supports on-the-flight compression which makes
 it possible to fit quite a lot of data to the flash.
 
 Similarly to JFFS2, UBIFS is tolerant of unclean reboots and power-cuts.
-It does not need stuff like ckfs.ext2. UBIFS automatically replays its
+It does not need stuff like fsck.ext2. UBIFS automatically replays its
 journal and recovers from crashes, ensuring that the on-flash data
 structures are consistent.
 
-- 
1.5.4.1

