Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbYAEPtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbYAEPtm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 10:49:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755606AbYAEPtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 10:49:19 -0500
Received: from [212.12.190.185] ([212.12.190.185]:52992 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756213AbYAEPtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 10:49:17 -0500
Message-Id: <200801051546.SAA08953@raad.intranet>
From: Al Boldi <a1426z@gawab.com>
To: linux-usb@vger.kernel.org
Subject: Re: [PATCH 4/5] USB Kconfig: Source "drivers/usb/gadget/Kconfig" for ARCH=arm
Date: Sat, 5 Jan 2008 18:42:52 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: David Brownell <david-b@pacbell.net>

Source "drivers/usb/gadget/Kconfig" for ARCH=arm.


Cc: David Brownell <david-b@pacbell.net>
Cc: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Al Boldi <a1426z@gawab.com>

---

--- 23.a/arch/arm/Kconfig
+++ 23.b/arch/arm/Kconfig
@@ -1049,6 +1049,8 @@ source "drivers/hid/Kconfig"
 
 source "drivers/usb/Kconfig"
 
+source "drivers/usb/gadget/Kconfig"
+
 source "drivers/mmc/Kconfig"
 
 source "drivers/rtc/Kconfig"

