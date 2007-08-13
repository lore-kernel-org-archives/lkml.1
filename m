Return-Path: <linux-kernel-owner+w=401wt.eu-S945191AbXHMMJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S945191AbXHMMJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967467AbXHMGkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:40:33 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2492 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967471AbXHMGkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:40:13 -0400
Date: Sun, 12 Aug 2007 23:39:53 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org, jacmet@sunsite.dk,
       akpm@linux-foundation.org
Subject: [PATCH] [547/2many] MAINTAINERS - XILINX UARTLITE SERIAL DRIVER
Message-ID: <46bffcb9.DiGt/lxDU9Y5bBxR%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index e400d13..14de518 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5175,6 +5175,7 @@ P:	Peter Korsgaard
 M:	jacmet@sunsite.dk
 L:	linux-serial@vger.kernel.org
 S:	Maintained
+F:	drivers/serial/uartlite.c
 
 X86 3-LEVEL PAGING (PAE) SUPPORT
 P:	Ingo Molnar
