Return-Path: <linux-kernel-owner+w=401wt.eu-S941554AbXHMHug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941554AbXHMHug (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966435AbXHMG04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:26:56 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4237 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966411AbXHMG0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:26:54 -0400
Date: Sun, 12 Aug 2007 23:26:10 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, dz@debian.org,
       akpm@linux-foundation.org
Subject: [PATCH] [151/2many] MAINTAINERS - DELL LAPTOP SMM DRIVER
Message-ID: <46bff982.f8IcwxsdYAM1Qdyp%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index ac1064d..cbf381c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1457,6 +1457,8 @@ P:	Massimo Dal Zotto
 M:	dz@debian.org
 W:	http://www.debian.org/~dz/i8k/
 S:	Maintained
+F:	drivers/char/i8k.c
+F:	include/linux/i8k.h
 
 DELL SYSTEMS MANAGEMENT BASE DRIVER (dcdbas)
 P:	Doug Warzecha
