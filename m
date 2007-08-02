Return-Path: <linux-kernel-owner+w=401wt.eu-S1755210AbXHBWBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbXHBWBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 18:01:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755547AbXHBWAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 18:00:50 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:46665 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398AbXHBWAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 18:00:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=GlDyjbCIqT4UKS3ufNObdjmHIaiNJpRbybbI315CxAYJzeJ/EalUo7hmmWUgyGFFOAmslIum7Xn05o7m9BM+vkK09k2VGhxmL0nlMq9Fbuifd4tNdHm/Z8gWa44o/k3lIPfAg49DtSkbl1OtnOOauIzucd9F6kTiuR24nv9hsfM=
Message-ID: <46B25403.90902@googlemail.com>
Date: Fri, 03 Aug 2007 00:00:35 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] kernel-parameters.txt : watchdog.txt should be wdt.txt 
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation/watchdog/watchdog.txt does not exist, it is Documentation/watchdog/wdt.txt

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>

---

 Documentation/kernel-parameters.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index efdb42f..a326487 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1922,7 +1922,7 @@ and is between 256 and 4096 characters. It is defined in the file
 			See header of drivers/scsi/wd7000.c.
 
 	wdt=		[WDT] Watchdog
-			See Documentation/watchdog/watchdog.txt.
+			See Documentation/watchdog/wdt.txt.
 
 	xd=		[HW,XT] Original XT pre-IDE (RLL encoded) disks.
 	xd_geo=		See header of drivers/block/xd.c.
