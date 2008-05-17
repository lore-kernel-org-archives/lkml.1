Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbYEQLbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbYEQLbY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 07:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbYEQLbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 07:31:15 -0400
Received: from mailbox2.myri.com ([64.172.73.26]:1874 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752472AbYEQLbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 07:31:14 -0400
X-Greylist: delayed 2723 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 May 2008 07:31:14 EDT
Message-ID: <482EB750.3080102@myri.com>
Date: Sat, 17 May 2008 12:45:36 +0200
From: Brice Goglin <brice@myri.com>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080420)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@osdl.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH][MAINTAINERS] Add maintainers for myri10ge driver
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a MAINTAINERS entry for the myri10ge driver.

Signed-off-by: Brice Goglin <brice@myri.com>
---
 MAINTAINERS |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-2.6.git/MAINTAINERS
===================================================================
--- linux-2.6.git.orig/MAINTAINERS	2008-05-13 20:29:45.000000000 +0200
+++ linux-2.6.git/MAINTAINERS	2008-05-13 20:30:32.000000000 +0200
@@ -2808,6 +2808,15 @@
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
+MYRICOM MYRI-10G 10GbE DRIVER (MYRI10GE)
+P:	Andrew Gallatin
+M:	gallatin@myri.com
+P:	Brice Goglin
+M:	brice@myri.com
+L:	netdev@vger.kernel.org
+W:	http://www.myri.com/scs/download-Myri10GE.html
+S:	Supported
+
 NATSEMI ETHERNET DRIVER (DP8381x)
 P: 	Tim Hockin
 M:	thockin@hockin.org

