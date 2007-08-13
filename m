Return-Path: <linux-kernel-owner+w=401wt.eu-S933546AbXHMKgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933546AbXHMKgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967308AbXHMGgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:36:05 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1777 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967296AbXHMGfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:35:46 -0400
Date: Sun, 12 Aug 2007 23:35:32 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, akpm@linux-foundation.org
Subject: [PATCH] [427/2many] MAINTAINERS - SENSABLE PHANTOM
Message-ID: <46bffbb4./tDYabre5MbiyGUf%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 127502e..04c969c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4068,6 +4068,8 @@ SENSABLE PHANTOM
 P:	Jiri Slaby
 M:	jirislaby@gmail.com
 S:	Maintained
+F:	drivers/misc/phantom.c
+F:	include/linux/phantom.h
 
 SERIAL ATA (SATA) SUBSYSTEM:
 P:	Jeff Garzik
