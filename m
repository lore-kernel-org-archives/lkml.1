Return-Path: <linux-kernel-owner+w=401wt.eu-S1761572AbXHWM4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761572AbXHWM4L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 08:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758085AbXHWMz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 08:55:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59354 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757726AbXHWMz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 08:55:57 -0400
Date: Thu, 23 Aug 2007 14:55:40 +0200
From: andre@finow14.de
To: joern@wohnheim.fh-wedel.de
Cc: linux-kernel@vger.kernel.org, Andre Haupt <andre@finow14.de>
Subject: [patch 1/1] fix a trivial typo in scripts/checkstack.pl
Message-ID: <20070823125540.GA19389@ahaupt-debian-vm.localdomain>
Mail-Followup-To: joern@wh.fh-wedel.de, linux-kernel@vger.kernel.org,
	Andre Haupt <andre@finow14.de>
References: <20070823125227.294913273@finow14.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix_trivial_typo_in_checkstack.pl"
User-Agent: quilt/0.45-1
X-Provags-ID: V01U2FsdGVkX19QoKD79sugTgfxSDuDBQpyg3jZDw3xTUsRagE
 6eO9UHIKxUEyqHtHtE5WPaNocYuOvrBFkCvPC8wcmqJpLQ7+JZ
 vLhmGInD4iCHlN9sUMtUTbM6Ucjcl+v
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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
 

--
