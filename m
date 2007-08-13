Return-Path: <linux-kernel-owner+w=401wt.eu-S1033065AbXHMSTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033065AbXHMSTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 14:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S974365AbXHMSBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 14:01:00 -0400
Received: from ag-out-0708.google.com ([72.14.246.248]:41453 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S973418AbXHMSAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 14:00:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:date:to:subject:cc:message-id;
        b=Uxj7bx3sonH/Is4X5N2BRx+srW1U3O1yMpxkURzTQx5vQl3Kwz30hSob5sm49KSM3rjj0gvZc81TA90grRorl9DsHpGnU7rTyGPo3GmTA6Lulu3VNn9Aqy5KU/xwOM09Ukg17VY+A0qfGzuKlg9YxDc7cPJRk52/TfhU6zpQlEQ=
From: mbressers@gmail.com
Date: Mon, 13 Aug 2007 20:02:13 +0200
To: linux-usb-devel@lists.sourceforge.net
Subject: [PATCH] [TRIVIAL] fix spelling mistake in drivers/usb/host/Kconfig
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Message-ID: <46c09c50.06e9300a.7fac.0878@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maarten Bressers <mbressers@gmail.com>

Greetings,

A very trivial patch: fixes a spelling mistake in drivers/usb/host/Kconfig,
wrt the R8A66597_HCD driver. The patch applies to kernel 2.6.23-rc3.

Signed-off by: Maarten Bressers <mbressers@gmail.com>

---

--- a/drivers/usb/host/Kconfig.orig	2007-08-13 19:40:34.000000000 +0200
+++ b/drivers/usb/host/Kconfig	2007-08-13 19:40:44.000000000 +0200
@@ -237,7 +237,7 @@ config USB_SL811_CS
 	  module will be called "sl811_cs".
 
 config USB_R8A66597_HCD
-	tristate "R8A66597 HCD suppoort"
+	tristate "R8A66597 HCD support"
 	depends on USB
 	help
 	  The R8A66597 is a USB 2.0 host and peripheral controller.
