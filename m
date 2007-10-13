Return-Path: <linux-kernel-owner+w=401wt.eu-S1761106AbXJMEU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761106AbXJMEU4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 00:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbXJMETA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 00:19:00 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:30080 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbXJMES7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 00:18:59 -0400
Date: Fri, 12 Oct 2007 21:17:35 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 4/5] docbook/mcabook: fixup x86 path/file names
Message-Id: <20071012211735.df41a9a1.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix docbook templates for new x86 path/filenames:
docproc: linux-2.6.23-git2/include/asm-i386/mca_dma.h: No such file or directory

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/mcabook.tmpl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.23-git2.orig/Documentation/DocBook/mcabook.tmpl
+++ linux-2.6.23-git2/Documentation/DocBook/mcabook.tmpl
@@ -101,7 +101,7 @@
 
   <chapter id="dmafunctions">
      <title>DMA Functions Provided</title>
-!Iinclude/asm-i386/mca_dma.h
+!Iinclude/asm-x86/mca_dma.h
   </chapter>
 
 </book>
