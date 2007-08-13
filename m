Return-Path: <linux-kernel-owner+w=401wt.eu-S966639AbXHMJsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966639AbXHMJsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967130AbXHMGdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:33:37 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1361 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764539AbXHMGda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:33:30 -0400
Date: Sun, 12 Aug 2007 23:33:10 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       laforge@gnumonks.org, akpm@linux-foundation.org
Subject: [PATCH] [354/2many] MAINTAINERS - OMNIKEY CARDMAN 4000 DRIVER
Message-ID: <46bffb26.8E5YcfR0KIWYP8jz%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index d2c6850..883d696 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3411,6 +3411,8 @@ OMNIKEY CARDMAN 4000 DRIVER
 P:	Harald Welte
 M:	laforge@gnumonks.org
 S:	Maintained
+F:	drivers/char/pcmcia/cm4000_cs.c
+F:	include/linux/cm4000_cs.h
 
 OMNIKEY CARDMAN 4040 DRIVER
 P:	Harald Welte
