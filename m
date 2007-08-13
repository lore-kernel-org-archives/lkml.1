Return-Path: <linux-kernel-owner+w=401wt.eu-S941785AbXHMHZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941785AbXHMHZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966202AbXHMGZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:25:32 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3978 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938552AbXHMGZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:25:22 -0400
Date: Sun, 12 Aug 2007 23:25:00 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       akpm@linux-foundation.org
Subject: [PATCH] [115/2many] MAINTAINERS - BSG (block layer generic sg v4
 driver)
Message-ID: <46bff93c.xBAv4jj6C/2mJu6C%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 0ee8069..4ad8cd5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1118,6 +1118,8 @@ P:	FUJITA Tomonori
 M:	fujita.tomonori@lab.ntt.co.jp
 L:	linux-scsi@vger.kernel.org
 S:	Supported
+F:	block/bsg.c
+F:	include/linux/bsg.h
 
 BTTV VIDEO4LINUX DRIVER
 P:	Mauro Carvalho Chehab
