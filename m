Return-Path: <linux-kernel-owner+w=401wt.eu-S1763148AbXHWNR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763148AbXHWNR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 09:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760861AbXHWNRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 09:17:19 -0400
Received: from lazybastard.de ([212.112.238.170]:36670 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760883AbXHWNRS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 09:17:18 -0400
Date: Thu, 23 Aug 2007 15:13:02 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Andrew Morton <akpm@osdl.org>
Cc: andre@finow14.de, joern@logfs.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/1] fix a trivial typo in scripts/checkstack.pl
Message-ID: <20070823131302.GA24870@lazybastard.org>
References: <20070823125227.294913273@finow14.de> <20070823125540.GA19389@ahaupt-debian-vm.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20070823125540.GA19389@ahaupt-debian-vm.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial change in a comment.

Signed-off-by: Jörn Engel <joern@logfs.org>
Signed-off-by: Andre Haupt <andre@finow14.de>
---
Index: linus/scripts/checkstack.pl
===================================================================
--- linus.orig/scripts/checkstack.pl	2007-08-23 14:25:03.000000000 +0200
+++ linus/scripts/checkstack.pl	2007-08-23 14:42:13.000000000 +0200
@@ -14,7 +14,7 @@
 #	M68k port by Geert Uytterhoeven and Andreas Schwab
 #
 #	Usage:
-#	objdump -d vmlinux | stackcheck.pl [arch]
+#	objdump -d vmlinux | scripts/checkstack.pl [arch]
 #
 #	TODO :	Port to all architectures (one regex per arch)
 

Jörn

-- 
Correctness comes second.
Features come third.
Performance comes last.
Maintainability is easily forgotten.
