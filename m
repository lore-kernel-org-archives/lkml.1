Return-Path: <linux-kernel-owner+w=401wt.eu-S1759910AbZAMUa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759910AbZAMUa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 15:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758549AbZAMU1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 15:27:52 -0500
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2535 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758370AbZAMU1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 15:27:50 -0500
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 10/10] MAINTAINERS - Update FPU Emulator contact address and web page
Date: Tue, 13 Jan 2009 12:28:18 -0800
Message-Id: <1231878498-25171-11-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1231878498-25171-1-git-send-email-joe@perches.com>
References: <1231878498-25171-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 221c944..331cf92 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2079,8 +2079,8 @@ F:	include/linux/firmware.h
 
 FPU EMULATOR
 P:	Bill Metzenthen
-M:	billm@suburbia.net
-W:	http://suburbia.net/~billm/floating-point/emulator/
+M:	billm@melbpc.org.au
+W:	http://floatingpoint.sourceforge.net/emulator/index.html
 S:	Maintained
 F:	arch/x86/math-emu/
 
-- 
1.6.0.2

