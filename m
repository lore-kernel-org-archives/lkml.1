Return-Path: <linux-kernel-owner+w=401wt.eu-S969016AbXHMIUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969016AbXHMIUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966324AbXHMG2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:28:52 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4542 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966729AbXHMG2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:28:49 -0400
Date: Sun, 12 Aug 2007 23:28:36 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [218/2many] MAINTAINERS - HIGH-RESOLUTION TIMERS,
 CLOCKEVENTS, DYNTICKS
Message-ID: <46bffa14.uS7V9tvGL3tGxHWo%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 4a8770c..0202a00 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2079,6 +2079,10 @@ P:	Thomas Gleixner
 M:	tglx@linutronix.de
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	Documentation/hrtimer/
+F:	Documentation/hrtimers/
+F:	kernel/hrtimer.c
+F:	include/linux/hrtimer.h
 
 HIGH-SPEED SCC DRIVER FOR AX.25
 P:	Klaus Kudielka
