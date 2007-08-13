Return-Path: <linux-kernel-owner+w=401wt.eu-S942875AbXHMJeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942875AbXHMJeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966963AbXHMGcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:32:46 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1214 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967032AbXHMGck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:32:40 -0400
Date: Sun, 12 Aug 2007 23:32:19 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       drzeus-mmc@drzeus.cx, akpm@linux-foundation.org
Subject: [PATCH] [327/2many] MAINTAINERS - MULTIMEDIA CARD (MMC) AND
 SECURE DIGITAL (SD) SUBSYSTEM
Message-ID: <46bffaf3.MQXPpMg3QctAk0bQ%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 88ef194..b9748db 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3141,6 +3141,8 @@ P:	Pierre Ossman
 M:	drzeus-mmc@drzeus.cx
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	drivers/mmc/
+F:	include/linux/mmc/
 
 MULTISOUND SOUND DRIVER
 P:	Andrew Veliath
