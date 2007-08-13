Return-Path: <linux-kernel-owner+w=401wt.eu-S943072AbXHMIK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943072AbXHMIK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966450AbXHMG2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:28:22 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4454 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966534AbXHMG2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:28:17 -0400
Date: Sun, 12 Aug 2007 23:27:58 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       billm@suburbia.net, akpm@linux-foundation.org
Subject: [PATCH] [199/2many] MAINTAINERS - FPU EMULATOR
Message-ID: <46bff9ee.Mm3cyq3YaLAFS8wa%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 18dfe29..1e7e562 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1914,6 +1914,7 @@ P:	Bill Metzenthen
 M:	billm@suburbia.net
 W:	http://suburbia.net/~billm/floating-point/emulator/
 S:	Maintained
+F:	arch/i386/math-emu/
 
 FRAME RELAY DLCI/FRAD (Sangoma drivers too)
 P:	Mike McLagan
