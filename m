Return-Path: <linux-kernel-owner+w=401wt.eu-S1757525AbYD3DLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525AbYD3DLJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 23:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbYD3DK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 23:10:57 -0400
Received: from xenotime.net ([66.160.160.81]:36059 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751214AbYD3DK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 23:10:57 -0400
Date: Tue, 29 Apr 2008 20:10:55 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: linux-kernel@vger.kernel.org
cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       mporter@kernel.crashing.org
Subject: [PATCH] docbook: fix fatal rapidio yet again (and more to come)
Message-ID: <Pine.LNX.4.64.0804292009000.18219@shark.he.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Don't refer to file that no longer exists:
docproc: linux-2.6.25-git14/arch/powerpc/kernel/rio.c: No such file or directory

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/rapidio.tmpl |    1 -
 1 file changed, 1 deletion(-)

--- linux-2.6.25-git14.orig/Documentation/DocBook/rapidio.tmpl
+++ linux-2.6.25-git14/Documentation/DocBook/rapidio.tmpl
@@ -133,7 +133,6 @@
 !Idrivers/rapidio/rio-sysfs.c
      </sect1>
      <sect1 id="PPC32_support"><title>PPC32 support</title>
-!Iarch/powerpc/kernel/rio.c
 !Earch/powerpc/sysdev/fsl_rio.c
 !Iarch/powerpc/sysdev/fsl_rio.c
      </sect1>
