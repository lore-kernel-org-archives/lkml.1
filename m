Return-Path: <linux-kernel-owner+w=401wt.eu-S937629AbXHMKWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937629AbXHMKWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967072AbXHMGfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:35:16 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1622 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967214AbXHMGex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:34:53 -0400
Date: Sun, 12 Aug 2007 23:34:35 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       al@alarsen.net, akpm@linux-foundation.org
Subject: [PATCH] [397/2many] MAINTAINERS - QNX4 FILESYSTEM
Message-ID: <46bffb7b.C++26gfic9//+SQA%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 6a99fe5..ed3be09 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3799,6 +3799,8 @@ M:	al@alarsen.net
 L:	linux-kernel@vger.kernel.org
 W:	http://www.alarsen.net/linux/qnx4fs/
 S:	Maintained
+F:	fs/qnx4
+F:	include/linux/qnx4_fs.h
 
 RADEON FRAMEBUFFER DISPLAY DRIVER
 P:	Benjamin Herrenschmidt
