Return-Path: <linux-kernel-owner+w=401wt.eu-S1752878AbZF1Q3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbZF1Q3v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756099AbZF1Q1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:27:23 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1082 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778AbZF1Q1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:27:18 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
Subject: [PATCH 08/62] arch/sh/boards/mach-se/7206/io.c: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:13 -0700
Message-Id: <14bb1ccd70fc437287bd496d0bf5210cf00e69e8.1246173680.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/sh/boards/mach-se/7206/io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/sh/boards/mach-se/7206/io.c b/arch/sh/boards/mach-se/7206/io.c
index 9c3a332..1804556 100644
--- a/arch/sh/boards/mach-se/7206/io.c
+++ b/arch/sh/boards/mach-se/7206/io.c
@@ -50,7 +50,7 @@ unsigned char se7206_inb_p(unsigned long port)
 
 unsigned short se7206_inw(unsigned long port)
 {
-	return *port2adr(port);;
+	return *port2adr(port);
 }
 
 void se7206_outb(unsigned char value, unsigned long port)
-- 
1.6.3.1.10.g659a0.dirty

