Return-Path: <linux-kernel-owner+w=401wt.eu-S933097AbXBLHiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933097AbXBLHiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:38:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933094AbXBLHiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:38:14 -0500
Received: from mail.suse.de ([195.135.220.2]:38395 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933092AbXBLHiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:38:09 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212837.963446000@suse.de>
In-Reply-To: <20070212837.963446000@suse.de>
To: Randy Dunlap <rdunlap@xenotime.net>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review II] [15/39] x86_64: list x86_64 quilt tree
Message-Id: <20070212073802.5B55A13D01@wotan.suse.de>
Date: Mon, 12 Feb 2007 08:38:02 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Randy Dunlap <rdunlap@xenotime.net>

List x86_64 quilt tree in MAINTAINERS.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

Index: linux/MAINTAINERS
===================================================================
--- linux.orig/MAINTAINERS
+++ linux/MAINTAINERS
@@ -3735,6 +3735,7 @@ P:	Andi Kleen
 M:	ak@suse.de
 L:	discuss@x86-64.org
 W:	http://www.x86-64.org
+T:	quilt ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt-current
 S:	Maintained
 
 YAM DRIVER FOR AX.25
