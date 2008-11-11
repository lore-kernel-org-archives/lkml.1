Return-Path: <linux-kernel-owner+w=401wt.eu-S1755156AbYKKCtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbYKKCtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 21:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754065AbYKKCtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 21:49:07 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52706 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628AbYKKCtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 21:49:06 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] doc: fix grub spell
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20081111114723.6176.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 11 Nov 2008 11:49:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I met okuji-san (GRUB maintainer) yesterday.
He said GRuB isn't correct spell and he want to fix it.

So, I'd like to do that.


------------------------------------------------------------
GRuB isn't correct spell.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 Documentation/x86/boot.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/Documentation/x86/boot.txt
===================================================================
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -349,7 +349,7 @@ Protocol:	2.00+
 	3  SYSLINUX
 	4  EtherBoot
 	5  ELILO
-	7  GRuB
+	7  GRUB
 	8  U-BOOT
 	9  Xen
 	A  Gujin


