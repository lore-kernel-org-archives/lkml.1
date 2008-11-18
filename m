Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbYKRRQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbYKRRQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 12:16:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbYKRRNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 12:13:40 -0500
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4482 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbYKRRNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 12:13:34 -0500
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@strlen.de>,
       Pavel Machek <pavel@suse.cz>
Subject: [PATCH 10/10] MAINTAINERS - Update FPU Emulator contact address and web page
Date: Tue, 18 Nov 2008 09:13:22 -0800
Message-Id: <1227028402-1548-11-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1227028402-1548-1-git-send-email-joe@perches.com>
References: <1227028402-1548-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1637d55..22bfe9b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2062,8 +2062,8 @@ F:	include/linux/firmware.h
 
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

