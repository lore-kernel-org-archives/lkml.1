Return-Path: <linux-kernel-owner+w=401wt.eu-S1764262AbYFTUaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764262AbYFTUaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761422AbYFTUUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:20:42 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35209 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761411AbYFTUUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:20:42 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 40/70] tty-usb-hp4x: Fix overlong line
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:03:17 +0100
Message-ID: <20080620200315.1479.72384.stgit@localhost.localdomain>
In-Reply-To: <20080620195406.1479.12620.stgit@localhost.localdomain>
References: <20080620195406.1479.12620.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>



Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/usb/serial/hp4x.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)


diff --git a/drivers/usb/serial/hp4x.c b/drivers/usb/serial/hp4x.c
index 75b88b3..ab90586 100644
--- a/drivers/usb/serial/hp4x.c
+++ b/drivers/usb/serial/hp4x.c
@@ -9,7 +9,8 @@
  *	the Free Software Foundation; either version 2 of the License, or
  *	(at your option) any later version.
  *
- * See Documentation/usb/usb-serial.txt for more information on using this driver
+ * See Documentation/usb/usb-serial.txt for more information on using this
+ * driver
  */
 
 #include <linux/kernel.h>

