Return-Path: <linux-kernel-owner+w=401wt.eu-S1761717AbXHMKEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761717AbXHMKEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967181AbXHMGeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:34:16 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1499 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967172AbXHMGeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:34:08 -0400
Date: Sun, 12 Aug 2007 23:33:56 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, petero2@telia.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [378/2many] MAINTAINERS - PKTCDVD DRIVER
Message-ID: <46bffb54.rCZtomMYuPQaIbfu%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index e165480..ae5843f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3628,6 +3628,8 @@ P:	Peter Osterlund
 M:	petero2@telia.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	drivers/block/pktcdvd.c
+F:	include/linux/pktcdvd.h
 
 POSIX CLOCKS and TIMERS
 P:	Thomas Gleixner
