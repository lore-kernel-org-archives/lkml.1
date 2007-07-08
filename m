Return-Path: <linux-kernel-owner+w=401wt.eu-S1757443AbXGHTFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbXGHTFU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 15:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756336AbXGHTFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 15:05:09 -0400
Received: from dns.hk.18mail.cn ([210.245.210.181]:38602 "EHLO
	hkm1.server.hk.18mail.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225AbXGHTFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 15:05:08 -0400
X-Greylist: delayed 1001 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Jul 2007 15:05:08 EDT
Subject: [PATCH] Update 2.4 maintainer in document
From: Li Yang <leo@zh-kernel.org>
Reply-To: leo@zh-kernel.org
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: zh-kernel.org
Date: Mon, 09 Jul 2007 03:05:07 +0800
Message-Id: <1183921507.6235.31.camel@leo-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Update the maintainer of 2.4 kernel in Documentations/SubmittingPatches.

Signed-off-by: Li Yang <leo@zh-kernel.org>
---
 Documentation/SubmittingDrivers |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/Documentation/SubmittingDrivers
b/Documentation/SubmittingDrivers
index d7e2642..24f2eb4 100644
--- a/Documentation/SubmittingDrivers
+++ b/Documentation/SubmittingDrivers
@@ -36,8 +36,7 @@ Linux 2.4:
 	If the code area has a general maintainer then please submit it to
 	the maintainer listed in MAINTAINERS in the kernel file. If the
 	maintainer does not respond or you cannot find the appropriate
-	maintainer then please contact Marcelo Tosatti
-	<marcelo.tosatti@cyclades.com>.
+	maintainer then please contact Willy Tarreau <w@1wt.eu>.
 
 Linux 2.6:
 	The same rules apply as 2.4 except that you should follow linux-kernel



