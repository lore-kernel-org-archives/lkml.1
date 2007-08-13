Return-Path: <linux-kernel-owner+w=401wt.eu-S942462AbXHMHnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942462AbXHMHnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966255AbXHMG0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:26:33 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4174 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966332AbXHMG0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:26:31 -0400
Date: Sun, 12 Aug 2007 23:26:19 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [155/2many] MAINTAINERS - DIRECTORY NOTIFICATION
Message-ID: <46bff98b.5op7z731zFIEDTr8%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index edebf01..0b054e1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1499,6 +1499,8 @@ P:	Stephen Rothwell
 M:	sfr@canb.auug.org.au
 L:	linux-kernel@vger.kernel.org
 S:	Supported
+F:	fs/dnotify.c
+F:	include/linux/dnotify.h
 
 DISK GEOMETRY AND PARTITION HANDLING
 P:	Andries Brouwer
