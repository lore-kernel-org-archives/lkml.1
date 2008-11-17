Return-Path: <linux-kernel-owner+w=401wt.eu-S1754926AbYKQWAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926AbYKQWAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 17:00:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754478AbYKQWAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 17:00:38 -0500
Received: from monster.nessie.de ([84.200.20.120]:40497 "EHLO
	monster.nessie.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbYKQWAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 17:00:37 -0500
X-Greylist: delayed 1252 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Nov 2008 17:00:37 EST
Message-ID: <4921E49F.6040006@nessie.de>
Date: Mon, 17 Nov 2008 22:39:43 +0100
From: Michael Roth <mroth@nessie.de>
User-Agent: Thunderbird 2.0.0.17 (X11/20080927)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: patch: drivers/usb/serial/cp2101.c: New vendor/product ID
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------010001050505010300000906"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010001050505010300000906
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hello list,

please, could somebody include this vendor/product-id into the kernel?

I'm a newbie to this list. Thanks for your patience.


Michael


--------------010001050505010300000906
Content-Type: text/plain;
 name="cp2101.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="cp2101.patch"

--- linux-2.6.27.6/drivers/usb/serial/cp2101.c.orig	2008-11-17 21:06:55.000000000 +0100
+++ linux-2.6.27.6/drivers/usb/serial/cp2101.c	2008-11-17 21:07:31.000000000 +0100
@@ -85,6 +85,7 @@
 	{ USB_DEVICE(0x10C4, 0x8218) }, /* Lipowsky Industrie Elektronik GmbH, HARP-1 */
 	{ USB_DEVICE(0x10c4, 0x8293) }, /* Telegesys ETRX2USB */
 	{ USB_DEVICE(0x10C4, 0x8341) }, /* Siemens MC35PU GPRS Modem */
+	{ USB_DEVICE(0x10c4, 0x83a8) }, /* Amber Wireless AMB2560 */
 	{ USB_DEVICE(0x10C4, 0xEA60) }, /* Silicon Labs factory default */
 	{ USB_DEVICE(0x10C4, 0xEA61) }, /* Silicon Labs factory default */
 	{ USB_DEVICE(0x10C4, 0xF001) }, /* Elan Digital Systems USBscope50 */

--------------010001050505010300000906--
