Return-Path: <linux-kernel-owner+w=401wt.eu-S1759498AbZFPPEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759498AbZFPPEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 11:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759571AbZFPPEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 11:04:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44050 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759556AbZFPPEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 11:04:07 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 7/9] MAINTAINERS: update 8250 section, give Alan Cox a name
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Tue, 16 Jun 2009 17:01:52 +0100
Message-ID: <20090616160139.10041.59110.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090616155552.10041.63479.stgit@t61.ukuu.org.uk>
References: <20090616155552.10041.63479.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 MAINTAINERS |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)


diff --git a/MAINTAINERS b/MAINTAINERS
index 2cb7566..09f6b3e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -157,9 +157,10 @@ S:	Maintained
 F:	drivers/net/r8169.c
 
 8250/16?50 (AND CLONE UARTS) SERIAL DRIVER
+P:	Alan Cox
+M:	alan@lxorguk.ukuu.org.uk
 L:	linux-serial@vger.kernel.org
 W:	http://serial.sourceforge.net
-M:	alan@lxorguk.ukuu.org.uk
 S:	Odd Fixes
 F:	drivers/serial/8250*
 F:	include/linux/serial_8250.h

