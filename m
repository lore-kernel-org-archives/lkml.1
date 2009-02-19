Return-Path: <linux-kernel-owner+w=401wt.eu-S1759323AbZBSVsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759323AbZBSVsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 16:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757936AbZBSVsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 16:48:16 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44082 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759024AbZBSVsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 16:48:15 -0500
Date: Thu, 19 Feb 2009 16:48:14 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] [trivial] fix references to Documentation/x86/i386/boot.txt
Message-ID: <20090219214814.GQ17272@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499DCF42.3030306@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@redhat.com>

The amazing dancing boot.txt file has jumped places again. :)

Signed-off-by: Kyle McMartin <kyle@redhat.com>

---
Resending to x86@kernel.org, cheers.

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
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

