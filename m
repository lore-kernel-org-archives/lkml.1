Return-Path: <linux-kernel-owner+w=401wt.eu-S1764332AbXHMWZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764332AbXHMWZB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 18:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbXHMWYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 18:24:50 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:28587 "EHLO
	outbound9-dub-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752680AbXHMWYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 18:24:49 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <46C0DA2B.6080407@am.sony.com>
Date: Mon, 13 Aug 2007 15:24:43 -0700
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: joe@perches.com
CC: torvalds@linux-foundation.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, cbe-oss-dev@ozlabs.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] [392/2many] MAINTAINERS - PS3 PLATFORM SUPPORT
References: <46bffb71.JWcVvIR5pg3biTEh%joe@perches.com>
In-Reply-To: <46bffb71.JWcVvIR5pg3biTEh%joe@perches.com>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Aug 2007 22:24:44.0442 (UTC) FILETIME=[BFE4CFA0:01C7DDF8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: joe@perches.com

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
---
I also maintain the file include/asm-powerpc/lv1call.h.
This updated patch adds that file.

-Geoff

 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3015,6 +3015,13 @@ M:	geoffrey.levand@am.sony.com
 L:	linuxppc-dev@ozlabs.org
 L:	cbe-oss-dev@ozlabs.org
 S:	Supported
+F:	arch/powerpc/boot/ps3*
+F:	arch/powerpc/platforms/ps3/
+F:	drivers/*/ps3*
+F:	drivers/ps3/
+F:	drivers/usb/host/*ps3.c
+F:	include/asm-powerpc/ps3*
+F:	include/asm-powerpc/lv1call.h
 
 PVRUSB2 VIDEO4LINUX DRIVER
 P:	Mike Isely

