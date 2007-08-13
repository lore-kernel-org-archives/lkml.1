Return-Path: <linux-kernel-owner+w=401wt.eu-S967613AbXHMGl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967613AbXHMGl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965811AbXHMGW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:22:58 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3553 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965781AbXHMGWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:22:53 -0400
Date: Sun, 12 Aug 2007 23:22:39 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       info-linux@geode.amd.com, akpm@linux-foundation.org
Subject: [PATCH] [40/2many] MAINTAINERS - AMD GEODE PROCESSOR/CHIPSET
 SUPPORT
Message-ID: <46bff8af.7lz63hibTNcIpDda%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 47d1ca1..35ebb00 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -391,6 +391,11 @@ M:	info-linux@geode.amd.com
 L:	info-linux@geode.amd.com
 W:	http://www.amd.com/us-en/ConnectivitySolutions/TechnicalResources/0,,50_2334_2452_11363,00.html
 S:	Supported
+F:	arch/i386/kernel/geode.c
+F:	drivers/char/hw-random/geode*
+F:	drivers/crypto/geode*
+F:	drivers/video/geode/
+F:	include/asm-i386/geode.h
 
 AMS (Apple Motion Sensor) DRIVER
 P:	Stelian Pop
