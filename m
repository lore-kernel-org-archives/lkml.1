Return-Path: <linux-kernel-owner+w=401wt.eu-S939622AbXGSTJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939622AbXGSTJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 15:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764220AbXGSTJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 15:09:12 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:55534 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763373AbXGSTJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 15:09:11 -0400
Date: Thu, 19 Jul 2007 13:09:10 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@osdl.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Update .gitignore for arch/i386/boot
Message-ID: <20070719190910.GX14791@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


With the new setup code, we generate a couple more files

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

diff --git a/arch/i386/boot/.gitignore b/arch/i386/boot/.gitignore
index 495f20c..1846514 100644
--- a/arch/i386/boot/.gitignore
+++ b/arch/i386/boot/.gitignore
@@ -1,3 +1,5 @@
 bootsect
 bzImage
 setup
+setup.bin
+setup.elf

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
