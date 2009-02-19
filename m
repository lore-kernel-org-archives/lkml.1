Return-Path: <linux-kernel-owner+w=401wt.eu-S1753142AbZBSB7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbZBSB7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 20:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754237AbZBSB7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 20:59:07 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42560 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780AbZBSB7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 20:59:06 -0500
Date: Wed, 18 Feb 2009 20:59:04 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [trivial] fix references to Documentation/x86/i386/boot.txt
Message-ID: <20090219015904.GH17272@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@redhat.com>

The amazing dancing boot.txt file has jumped places again. :)

Signed-off-by: Kyle McMartin <kyle@redhat.com>

---
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index b182626..37b6a73 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -114,7 +114,7 @@ In addition, the following text indicates that the option:
 Parameters denoted with BOOT are actually interpreted by the boot
 loader, and have no meaning to the kernel directly.
 Do not modify the syntax of boot loader parameters without extreme
-need or coordination with <Documentation/x86/i386/boot.txt>.
+need or coordination with <Documentation/x86/boot.txt>.
 
 There are also arch-specific kernel-parameters not documented here.
 See for example <Documentation/x86/x86_64/boot-options.txt>.
@@ -2449,7 +2449,7 @@ and is between 256 and 4096 characters. It is defined in the file
 			See Documentation/fb/modedb.txt.
 
 	vga=		[BOOT,X86-32] Select a particular video mode
-			See Documentation/x86/i386/boot.txt and
+			See Documentation/x86/boot.txt and
 			Documentation/svga.txt.
 			Use vga=ask for menu.
 			This is actually a boot loader parameter; the value is
