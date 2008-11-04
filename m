Return-Path: <linux-kernel-owner+w=401wt.eu-S1755385AbYKDPvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbYKDPvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 10:51:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753919AbYKDPvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 10:51:23 -0500
Received: from tombstone.ecm.ub.es ([161.116.81.124]:3029 "EHLO
	tombstone.ecm.ub.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbYKDPvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 10:51:23 -0500
Message-ID: <49106F76.1090007@ecm.ub.es>
Date: Tue, 04 Nov 2008 16:51:18 +0100
From: Albert Comerma <albert@ecm.ub.es>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] SISUSB2VGA driver add 0x0711, 0x0903
Content-Type: multipart/mixed;
 boundary="------------020001030108080600030103"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020001030108080600030103
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

After some comments (thanks a lot) I resend the patch, hoping now it
reaches the adequate person.

Signed-off-by:  Albert Comerma <albert.comerma@gmail.com>


--------------020001030108080600030103
Content-Type: text/x-diff;
 name="sisusb.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sisusb.patch"

diff -r -u linux-2.6.27.4/drivers/usb/misc/sisusbvga/sisusb.c linux-2.6.27.4-new/drivers/usb/misc/sisusbvga/sisusb.c
--- linux-2.6.27.4/drivers/usb/misc/sisusbvga/sisusb.c	2008-10-26 00:05:07.000000000 +0200
+++ linux-2.6.27.4-new/drivers/usb/misc/sisusbvga/sisusb.c	2008-11-03 15:21:03.000000000 +0100
@@ -3270,6 +3270,7 @@
 	{ USB_DEVICE(0x0711, 0x0900) },
 	{ USB_DEVICE(0x0711, 0x0901) },
 	{ USB_DEVICE(0x0711, 0x0902) },
+	{ USB_DEVICE(0x0711, 0x0903) },
 	{ USB_DEVICE(0x0711, 0x0918) },
 	{ USB_DEVICE(0x182d, 0x021c) },
 	{ USB_DEVICE(0x182d, 0x0269) },



--------------020001030108080600030103--
