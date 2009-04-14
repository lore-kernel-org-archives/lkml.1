Return-Path: <linux-kernel-owner+w=401wt.eu-S1757775AbZDNSUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757775AbZDNSUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 14:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755225AbZDNSTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 14:19:53 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4429 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbZDNSTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:19:52 -0400
Subject: [PATCH] MAINTAINERS - Remove include/asm-*/suspend* file patterns
From: Joe Perches <joe@perches.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <len.brown@intel.com>, linux-pm@lists.linux-foundation.org
Content-Type: text/plain
Date: Tue, 14 Apr 2009 11:19:47 -0700
Message-Id: <1239733187.7994.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no more arches with suspend support using these directories.
    
Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 0cb20d8..5b4f1dd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2490,7 +2490,6 @@ F:	kernel/power/
 F:	include/linux/suspend.h
 F:	include/linux/freezer.h
 F:	include/linux/pm.h
-F:	include/asm-*/suspend*.h
 F:	arch/*/include/asm/suspend*.h
 
 HID CORE LAYER
@@ -5334,7 +5333,6 @@ F:	kernel/power/
 F:	include/linux/suspend.h
 F:	include/linux/freezer.h
 F:	include/linux/pm.h
-F:	include/asm-*/suspend.h
 
 SVGA HANDLING
 P:	Martin Mares


