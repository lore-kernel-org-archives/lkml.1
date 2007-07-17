Return-Path: <linux-kernel-owner+w=401wt.eu-S933188AbXGQHws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933188AbXGQHws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 03:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756121AbXGQHtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 03:49:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51001 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091AbXGQHth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 03:49:37 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] atl1: missing include
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jgarzik@pobox.com
Message-Id: <E1IAhoN-0001iy-T1@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Tue, 17 Jul 2007 08:49:35 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/atl1/atl1_main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/atl1/atl1_main.c b/drivers/net/atl1/atl1_main.c
index 4a18b88..fd1e156 100644
--- a/drivers/net/atl1/atl1_main.c
+++ b/drivers/net/atl1/atl1_main.c
@@ -75,6 +75,7 @@
 #include <linux/compiler.h>
 #include <linux/delay.h>
 #include <linux/mii.h>
+#include <linux/interrupt.h>
 #include <net/checksum.h>
 
 #include <asm/atomic.h>
-- 
1.5.3.GIT

