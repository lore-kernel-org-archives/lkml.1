Return-Path: <linux-kernel-owner+w=401wt.eu-S1763498AbXFGPa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763498AbXFGPa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 11:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761468AbXFGPaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 11:30:52 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54912 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755883AbXFGPaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 11:30:52 -0400
Date: Thu, 7 Jun 2007 16:36:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: corrections
Message-ID: <20070607163604.5cb371ec@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The UFS entry was misformatted
The NEC V850 links are all broken
The Berkshire watchdog links are all broken

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc4-mm2/MAINTAINERS linux-2.6.22-rc4-mm2/MAINTAINERS
--- linux.vanilla-2.6.22-rc4-mm2/MAINTAINERS	2007-06-07 14:26:08.000000000 +0100
+++ linux-2.6.22-rc4-mm2/MAINTAINERS	2007-06-07 14:38:22.000000000 +0100
@@ -777,11 +777,6 @@
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
-BERKSHIRE PRODUCTS PC WATCHDOG DRIVER
-P:	Kenji Hollis
-W:	http://ftp.bitgate.com/pcwd/
-S:	Maintained
-
 BFS FILE SYSTEM
 P:	Tigran A. Aivazian
 M:	tigran@aivazian.fsnet.co.uk
@@ -3959,10 +3954,6 @@
 
 UCLINUX FOR NEC V850
 P:	Miles Bader
-M:	uclinux-v850@lsi.nec.co.jp
-W:	http://www.ic.nec.co.jp/micro/uclinux/eng/
-W:	http://www.ee.nec.de/uclinux/
-S:	Supported
 
 UCLINUX FOR RENESAS H8/300
 P:	Yoshinori Sato
@@ -3971,10 +3962,10 @@
 S:	Supported
 
 UFS FILESYSTEM
-P: Evgeniy Dushistov
-M: dushistov@mail.ru
-L: linux-kernel@vger.kernel.org
-S: Maintained
+P:	Evgeniy Dushistov
+M:	dushistov@mail.ru
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
 
 USB DIAMOND RIO500 DRIVER
 P:	Cesar Miquel
