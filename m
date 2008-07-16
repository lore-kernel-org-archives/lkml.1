Return-Path: <linux-kernel-owner+w=401wt.eu-S1760045AbYGPOqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760045AbYGPOqK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 10:46:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756826AbYGPOp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 10:45:56 -0400
Received: from yorgi.telenet-ops.be ([195.130.133.69]:42224 "EHLO
	yorgi.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584AbYGPOp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 10:45:56 -0400
Date: Wed, 16 Jul 2008 16:45:28 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Woodhouse <dwmw2@infradead.org>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/base/Kconfig spelling: usees
Message-ID: <Pine.LNX.4.64.0807161645100.31409@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s/usees/uses/

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/base/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -53,7 +53,7 @@ config FIRMWARE_IN_KERNEL
 	  such firmware, and do not wish to use an initrd.
 
 	  This single option controls the inclusion of firmware for
-	  every driver which usees request_firmare() and ships its
+	  every driver which uses request_firmare() and ships its
 	  firmware in the kernel source tree, to avoid a proliferation
 	  of 'Include firmware for xxx device' options.
 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
