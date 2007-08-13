Return-Path: <linux-kernel-owner+w=401wt.eu-S943148AbXHMJdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943148AbXHMJdE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:33:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965903AbXHMGcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:32:42 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1206 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965772AbXHMGci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:32:38 -0400
Date: Sun, 12 Aug 2007 23:32:23 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, akpm@linux-foundation.org
Subject: [PATCH] [329/2many] MAINTAINERS - MULTITECH MULTIPORT CARD
 (ISICOM)
Message-ID: <46bffaf7.EQ2rPPIU9TvbGkfv%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index c74e9a6..409dd81 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3156,6 +3156,8 @@ P:	Jiri Slaby
 M:	jirislaby@gmail.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	drivers/char/isicom.c
+F:	include/linux/isicom.h
 
 NATSEMI ETHERNET DRIVER (DP8381x)
 P: 	Tim Hockin
