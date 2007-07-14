Return-Path: <linux-kernel-owner+w=401wt.eu-S1761432AbXGNLK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761432AbXGNLK1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 07:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756419AbXGNLKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 07:10:17 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:51489 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090AbXGNLKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 07:10:15 -0400
From: M4rkusXXL <M4rkusXXL@web.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] trival typo in usb R8A66597 HCD config
Date: Sat, 14 Jul 2007 13:10:12 +0200
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707141310.12293.M4rkusXXL@web.de>
X-Provags-ID: V01U2FsdGVkX1/OiHMXnF8D5LkRQrtcSzaAOuNWc8vwyOxzXyiU
	m+Lh3YPWxOmh/U5I/ytPWpbLAQwRuSOY3gLUyEARQT7Zi2ZMtZ
	zCaiybltA=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-2.6/drivers/usb/host/Kconfig  2007-07-14 13:00:15.000000000 
+0200
+++ linux-2.6-patched/drivers/usb/host/Kconfig  2007-07-14 
13:09:10.000000000 +0200
@@ -237,7 +237,7 @@
          module will be called "sl811_cs".

 config USB_R8A66597_HCD
-       tristate "R8A66597 HCD suppoort"
+       tristate "R8A66597 HCD support"
        depends on USB
        help
          The R8A66597 is a USB 2.0 host and peripheral controller.
