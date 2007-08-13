Return-Path: <linux-kernel-owner+w=401wt.eu-S944068AbXHMLIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S944068AbXHMLIE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967392AbXHMGhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:37:40 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2033 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967387AbXHMGhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:37:17 -0400
Date: Sun, 12 Aug 2007 23:37:03 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       hswong3i@gmail.com, hlhung3i@gmail.com, akpm@linux-foundation.org
Subject: [PATCH] [470/2many] MAINTAINERS - TCP LOW PRIORITY MODULE
Message-ID: <46bffc0f.E8NW2ppJgFoVM7kH%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index fc0589f..e45a848 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4462,12 +4462,13 @@ F:	include/net/pkt_cls.h
 F:	net/sched/
 
 TCP LOW PRIORITY MODULE
-P:	Wong Hoi Sing, Edison
+P:	Wong Hoi (Edison) Sing
 M:	hswong3i@gmail.com
-P:	Hung Hing Lun, Mike
+P:	Hung Hing (Mike) Lun
 M:	hlhung3i@gmail.com
 W:	http://tcp-lp-mod.sourceforge.net/
 S:	Maintained
+F:	net/ipv4/tcp_lp.c
 
 TI FLASH MEDIA INTERFACE DRIVER
 P:      Alex Dubov
