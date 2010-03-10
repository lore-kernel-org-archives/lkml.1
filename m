Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107Ab0CJUqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 15:46:17 -0500
Received: from mail.perches.com ([173.55.12.10]:1621 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757045Ab0CJUqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 15:46:16 -0500
Subject: [PATCH trivial] MAINTAINERS: Use tab not spaces for delimiter
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Mar 2010 12:46:14 -0800
Message-ID: <1268253974.24209.14.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keeps MAINTAINERS a bit more consistent.
done via sed -r -i -e 's/^([A-Z]):[ \t]+/\1:\t/g' MAINTAINERS

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |   40 ++++++++++++++++++++--------------------
 1 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c8a8b1f..93798bf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -791,12 +791,12 @@ M:	Michael Petchkovsky <mkpetch@internode.on.net>
 S:	Maintained
 
 ARM/NOMADIK ARCHITECTURE
-M:     Alessandro Rubini <rubini@unipv.it>
-M:     STEricsson <STEricsson_nomadik_linux@list.st.com>
-L:     linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-S:     Maintained
-F:     arch/arm/mach-nomadik/
-F:     arch/arm/plat-nomadik/
+M:	Alessandro Rubini <rubini@unipv.it>
+M:	STEricsson <STEricsson_nomadik_linux@list.st.com>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+S:	Maintained
+F:	arch/arm/mach-nomadik/
+F:	arch/arm/plat-nomadik/
 
 ARM/OPENMOKO NEO FREERUNNER (GTA02) MACHINE SUPPORT
 M:	Nelson Castillo <arhuaco@freaks-unidos.net>
@@ -1884,17 +1884,17 @@ F:	drivers/scsi/dpt*
 F:	drivers/scsi/dpt/
 
 DRBD DRIVER
-P:     Philipp Reisner
-P:     Lars Ellenberg
-M:     drbd-dev@lists.linbit.com
-L:     drbd-user@lists.linbit.com
-W:     http://www.drbd.org
-T:     git git://git.drbd.org/linux-2.6-drbd.git drbd
-T:     git git://git.drbd.org/drbd-8.3.git
-S:     Supported
-F:     drivers/block/drbd/
-F:     lib/lru_cache.c
-F:     Documentation/blockdev/drbd/
+P:	Philipp Reisner
+P:	Lars Ellenberg
+M:	drbd-dev@lists.linbit.com
+L:	drbd-user@lists.linbit.com
+W:	http://www.drbd.org
+T:	git git://git.drbd.org/linux-2.6-drbd.git drbd
+T:	git git://git.drbd.org/drbd-8.3.git
+S:	Supported
+F:	drivers/block/drbd/
+F:	lib/lru_cache.c
+F:	Documentation/blockdev/drbd/
 
 DRIVER CORE, KOBJECTS, AND SYSFS
 M:	Greg Kroah-Hartman <gregkh@suse.de>
@@ -3475,8 +3475,8 @@ F:	drivers/scsi/sym53c8xx_2/
 LTP (Linux Test Project)
 M:	Rishikesh K Rajak <risrajak@linux.vnet.ibm.com>
 M:	Garrett Cooper <yanegomi@gmail.com>
-M:     Mike Frysinger <vapier@gentoo.org>
-M:     Subrata Modak <subrata@linux.vnet.ibm.com>
+M:	Mike Frysinger <vapier@gentoo.org>
+M:	Subrata Modak <subrata@linux.vnet.ibm.com>
 L:	ltp-list@lists.sourceforge.net (subscribers-only)
 W:	http://ltp.sourceforge.net/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/galak/ltp.git
@@ -6135,7 +6135,7 @@ F:	arch/x86/
 X86 PLATFORM DRIVERS
 M:	Matthew Garrett <mjg@redhat.com>
 L:	platform-driver-x86@vger.kernel.org
-T:      git git://git.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86.git
 S:	Maintained
 F:	drivers/platform/x86
 


