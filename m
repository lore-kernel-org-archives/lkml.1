Return-Path: <linux-kernel-owner+w=401wt.eu-S941383AbXHML63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941383AbXHML63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967499AbXHMGjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:39:54 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2437 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967495AbXHMGjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:39:53 -0400
Date: Sun, 12 Aug 2007 23:39:39 -0700
From: joe@perches.com
To: wim@iguana.be, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [540/2many] MAINTAINERS - WATCHDOG DEVICE DRIVERS
Message-ID: <46bffcab.hvODrZFyIOzH/Lb/%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 71ffe5d..d8ee850 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5102,6 +5102,9 @@ P:	Wim Van Sebroeck
 M:	wim@iguana.be
 T:	git kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
 S:	Maintained
+F:	Documentation/watchdog/
+F:	drivers/char/watchdog/
+F:	include/linux/watchdog.h
 
 WAVELAN NETWORK DRIVER & WIRELESS EXTENSIONS
 P:	Jean Tourrilhes
