Return-Path: <linux-kernel-owner+w=401wt.eu-S1756742AbXKEO4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbXKEO4n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 09:56:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbXKEO4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 09:56:36 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:52393 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbXKEO4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 09:56:35 -0500
Date: Mon, 5 Nov 2007 15:56:12 +0100
From: Andre Haupt <andre@bitwigglers.org>
To: linux-kernel@vger.kernel.org
Cc: a.zummo@towertech.it, Andre Haupt <andre@bitwigglers.org>
Subject: [patch 1/1] ixp4xx: remove double include
Message-ID: <20071105145612.GA28736@ahaupt-debian-vm.localdomain>
References: <20071105145446.633718799@ahaupt-debian-vm.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=ixp4xx_fix_includes
User-Agent: quilt/0.45-1
X-Provags-ID: V01U2FsdGVkX1+adz920UUXwNPzXjKJndNAVUcUCF9aWhaANkG
 md+XsFi02zBoFyHjbecuF+pvSRt0sCVqdSfxqSOM7+T6fNOt/N
 KdmaiavuOmDiXlNDgZhdHrugcdSaBCQYDig6+0qDyE=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andre Haupt <andre@bitwigglers.org>
Signed-off-by: Andre Haupt <andre@bitwigglers.org>

---
 arch/arm/mach-ixp4xx/nslu2-power.c |    1 -
 1 file changed, 1 deletion(-)

Index: linus/arch/arm/mach-ixp4xx/nslu2-power.c
===================================================================
--- linus.orig/arch/arm/mach-ixp4xx/nslu2-power.c	2007-11-05 15:51:49.000000000 +0100
+++ linus/arch/arm/mach-ixp4xx/nslu2-power.c	2007-11-05 15:52:50.000000000 +0100
@@ -18,7 +18,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/reboot.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/reboot.h>

--
