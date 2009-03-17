Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbZCQXWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbZCQXWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 19:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbZCQXVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 19:21:00 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4391 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbZCQXU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 19:20:59 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 8/8] MAINTAINERS - Update FPU Emulator contact address and web page
Date: Tue, 17 Mar 2009 16:19:29 -0700
Message-Id: <1237331969-28565-9-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1237331969-28565-1-git-send-email-joe@perches.com>
References: <1237331969-28565-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 674158b..16ace54 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2113,8 +2113,8 @@ F:	include/linux/firmware.h
 
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

