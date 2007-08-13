Return-Path: <linux-kernel-owner+w=401wt.eu-S968898AbXHMIWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968898AbXHMIWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966748AbXHMG26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:28:58 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4558 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966354AbXHMG2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:28:55 -0400
Date: Sun, 12 Aug 2007 23:28:35 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz, jkosina@suse.cz,
       akpm@linux-foundation.org
Subject: [PATCH] [217/2many] MAINTAINERS - HID CORE LAYER
Message-ID: <46bffa13.u2UP+i4L1tdJi0Sf%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index bdbf999..4a8770c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2071,6 +2071,8 @@ M:	jkosina@suse.cz
 L:	linux-input@atrey.karlin.mff.cuni.cz
 T:	git kernel.org:/pub/scm/linux/kernel/git/jikos/hid.git
 S:	Maintained
+F:	drivers/hid/
+F:	include/linux/hid*
 
 HIGH-RESOLUTION TIMERS, CLOCKEVENTS, DYNTICKS
 P:	Thomas Gleixner
