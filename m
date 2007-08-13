Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbXHMKxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbXHMKxx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967227AbXHMGgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:36:49 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1931 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967304AbXHMGgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:36:44 -0400
Date: Sun, 12 Aug 2007 23:36:28 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, pcihpd-discuss@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kristen.c.accardi@intel.com,
       akpm@linux-foundation.org
Subject: [PATCH] [453/2many] MAINTAINERS - SHPC HOTPLUG DRIVER
Message-ID: <46bffbec.vT6bUux64nO3X1Sg%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 52c9db7..4af5d59 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4322,12 +4322,18 @@ M:	elf@buici.com
 W:	http://projects.buici.com/arm
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
 S:	Maintained
+F:	Documentation/arm/Sharp-LH/ADC-LH7-Touchscreen
+F:	arch/arm/mach-lh7a40x/
+F:	drivers/serial/serial_lh7a40x.c
+F:	drivers/*/*/*lh7a40*
+F:	include/asm-arm/arch-lh7a40x/
 
 SHPC HOTPLUG DRIVER
 P:	Kristen Carlson Accardi
 M:	kristen.c.accardi@intel.com
 L:	pcihpd-discuss@lists.sourceforge.net
 S:	Supported
+F:	drivers/pci/hotplug/shpchp*
 
 SECURE DIGITAL HOST CONTROLLER INTERFACE DRIVER
 P:	Pierre Ossman
