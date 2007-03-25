Return-Path: <linux-kernel-owner+w=401wt.eu-S964789AbXCYCPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964789AbXCYCPI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 22:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964806AbXCYCPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 22:15:07 -0400
Received: from mout2.freenet.de ([194.97.50.155]:48042 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964789AbXCYCPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 22:15:06 -0400
Message-ID: <4605DB21.30403@freenet.de>
Date: Sun, 25 Mar 2007 04:14:57 +0200
From: Patrick Ringl <patrick_@freenet.de>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de
Subject: [PATCH] cosmetic - minor typos in drivers/isdn/capi/Kconfig
Content-Type: multipart/mixed;
 boundary="------------060701080604000701020907"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060701080604000701020907
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

[ ... fixed one minor typo and adapted the word order ... ]


--- linux-2.6.20-o/drivers/isdn/capi/Kconfig    2007-03-18 
00:04:54.000000000 +0100
+++ linux-2.6.20/drivers/isdn/capi/Kconfig    2007-03-25 
04:10:24.000000000 +0200
@@ -17,7 +17,7 @@
     help
       If you say Y here, the kernelcapi driver can make verbose traces
       of CAPI messages. This feature can be enabled/disabled via IOCTL for
-      every controler (default disabled).
+      every controller (disabled by default).
       This will increase the size of the kernelcapi module by 20 KB.
       If unsure, say Y.



---


regards,
Patrick

--------------060701080604000701020907
Content-Type: text/plain;
 name="isdn_capi_typo_fix"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="isdn_capi_typo_fix"

--- linux-2.6.20-o/drivers/isdn/capi/Kconfig	2007-03-18 00:04:54.000000000 +0100
+++ linux-2.6.20/drivers/isdn/capi/Kconfig	2007-03-25 04:10:24.000000000 +0200
@@ -17,7 +17,7 @@
 	help
 	  If you say Y here, the kernelcapi driver can make verbose traces
 	  of CAPI messages. This feature can be enabled/disabled via IOCTL for
-	  every controler (default disabled).
+	  every controller (disabled by default).
 	  This will increase the size of the kernelcapi module by 20 KB.
 	  If unsure, say Y.
 

--------------060701080604000701020907--
