Return-Path: <linux-kernel-owner+w=401wt.eu-S937039AbXHMKTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937039AbXHMKTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967228AbXHMGfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:35:07 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1628 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967175AbXHMGe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:34:57 -0400
Date: Sun, 12 Aug 2007 23:34:43 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, mpm@selenic.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [401/2many] MAINTAINERS - RANDOM NUMBER DRIVER
Message-ID: <46bffb83.RXpi45ewO2bdMSZc%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index e62a648..a2484d5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3828,6 +3828,7 @@ RANDOM NUMBER DRIVER
 P:	Matt Mackall
 M:	mpm@selenic.com
 S:	Maintained
+F:	drivers/char/random.c
 
 RAPIDIO SUBSYSTEM
 P:	Matt Porter
