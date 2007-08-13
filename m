Return-Path: <linux-kernel-owner+w=401wt.eu-S964964AbXHMKvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964964AbXHMKvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967361AbXHMGgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:36:42 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1914 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967341AbXHMGgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:36:37 -0400
Date: Sun, 12 Aug 2007 23:36:23 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       chris@zankel.net, akpm@linux-foundation.org
Subject: [PATCH] [451/2many] MAINTAINERS - TENSILICA XTENSA PORT (xtensa):
Message-ID: <46bffbe7.8UT7uMa0kiZH+b7M%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index cd9cda4..e6d5c86 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4295,6 +4295,8 @@ TENSILICA XTENSA PORT (xtensa):
 P:	Chris Zankel
 M:	chris@zankel.net
 S:	Maintained
+F:	arch/extensa/
+F:	include/asm-xtensa/
 
 THINKPAD ACPI EXTRAS DRIVER
 P:	Henrique de Moraes Holschuh
