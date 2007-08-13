Return-Path: <linux-kernel-owner+w=401wt.eu-S934167AbXHMHeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934167AbXHMHeM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:34:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966054AbXHMG0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:26:05 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4088 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966246AbXHMGZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:25:59 -0400
Date: Sun, 12 Aug 2007 23:25:44 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, starvik@axis.com,
       linux-kernel@vger.kernel.org, dev-etrax@axis.com,
       akpm@linux-foundation.org
Subject: [PATCH] [138/2many] MAINTAINERS - CRIS PORT
Message-ID: <46bff968.zfOeygY/nxoo1SYh%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 07df33a..794fe99 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1341,6 +1341,8 @@ M:	starvik@axis.com
 L:	dev-etrax@axis.com
 W:	http://developer.axis.com
 S:	Maintained
+F:	arch/cris/
+F:	include/asm-cris/
 
 CRYPTO API
 P:	Herbert Xu
