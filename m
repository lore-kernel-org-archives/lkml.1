Return-Path: <linux-kernel-owner+w=401wt.eu-S941972AbXHMH2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941972AbXHMH2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966151AbXHMGZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:25:44 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4015 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966082AbXHMGZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:25:36 -0400
Date: Sun, 12 Aug 2007 23:25:23 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, nils@kernelconcepts.de,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [127/2many] MAINTAINERS - CIRRUS LOGIC CS4280/CS461x
 SOUNDDRIVER
Message-ID: <46bff953.GPbwdnQgAtHAZDHL%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 7f16b33..de652f5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1232,11 +1232,11 @@ S:	Maintained
 F:	drivers/usb/host/ohci-ep93xx.c
 
 CIRRUS LOGIC CS4280/CS461x SOUNDDRIVER
-P:	Cirrus Logic Corporation (kernel 2.2 driver)
-M:	Cirrus Logic Corporation, Thomas Woller <twoller@crystal.cirrus.com>
-P:	Nils Faerber (port to kernel 2.4)
-M:	Nils Faerber <nils@kernelconcepts.de>
+P:	Nils Faerber
+M:	nils@kernelconcepts.de
 S:	Maintained
+F:	Documentation/input/cs461x.txt
+F:	sound/pci/cs46xx/
 
 CODA FILE SYSTEM
 P:	Jan Harkes
