Return-Path: <linux-kernel-owner+w=401wt.eu-S932231AbYFTUjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231AbYFTUjz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762553AbYFTUXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:23:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58345 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762541AbYFTUXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:23:37 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 60/70] tty-usb-sierra: Coding style - minor
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:06:13 +0100
Message-ID: <20080620200610.1479.80215.stgit@localhost.localdomain>
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

 drivers/usb/serial/sierra.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index 892020d..2f6f152 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -757,7 +757,7 @@ failed_device_register:
 
 static void __exit sierra_exit(void)
 {
-	usb_deregister (&sierra_driver);
+	usb_deregister(&sierra_driver);
 	usb_serial_deregister(&sierra_device);
 }
 

