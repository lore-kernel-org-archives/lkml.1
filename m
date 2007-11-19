Return-Path: <linux-kernel-owner+w=401wt.eu-S1756732AbXKSPLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732AbXKSPLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 10:11:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754814AbXKSPLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 10:11:20 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45745 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754866AbXKSPLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:11:19 -0500
Date: Mon, 19 Nov 2007 15:09:36 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] 8250_hub6: codding style
Message-ID: <20071119150936.37c78c07@the-village.bc.nu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc2-mm1/drivers/serial/8250_hub6.c linux-2.6.24-rc2-mm1/drivers/serial/8250_hub6.c
--- linux.vanilla-2.6.24-rc2-mm1/drivers/serial/8250_hub6.c	2007-11-16 17:20:48.000000000 +0000
+++ linux-2.6.24-rc2-mm1/drivers/serial/8250_hub6.c	2007-11-16 18:35:39.000000000 +0000
@@ -23,18 +23,18 @@
 	}
 
 static struct plat_serial8250_port hub6_data[] = {
-	HUB6(0,0),
-	HUB6(0,1),
-	HUB6(0,2),
-	HUB6(0,3),
-	HUB6(0,4),
-	HUB6(0,5),
-	HUB6(1,0),
-	HUB6(1,1),
-	HUB6(1,2),
-	HUB6(1,3),
-	HUB6(1,4),
-	HUB6(1,5),
+	HUB6(0, 0),
+	HUB6(0, 1),
+	HUB6(0, 2),
+	HUB6(0, 3),
+	HUB6(0, 4),
+	HUB6(0, 5),
+	HUB6(1, 0),
+	HUB6(1, 1),
+	HUB6(1, 2),
+	HUB6(1, 3),
+	HUB6(1, 4),
+	HUB6(1, 5),
 	{ },
 };
 
