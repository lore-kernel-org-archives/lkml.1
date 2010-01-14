Return-Path: <linux-kernel-owner+w=401wt.eu-S1756909Ab0ANPxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab0ANPxo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 10:53:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756848Ab0ANPxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 10:53:42 -0500
Received: from mga14.intel.com ([143.182.124.37]:35341 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756776Ab0ANPxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 10:53:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="232737698"
From: Maciej Sosnowski <maciej.sosnowski@intel.com>
Subject: [PATCH] MAINTAINERS: transfer maintainership of I/OAT
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date: Thu, 14 Jan 2010 16:52:42 +0100
Message-ID: <20100114155217.11352.15918.stgit@linux.site>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams takes over I/OAT from Maciej Sosnowski

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
---

 MAINTAINERS |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c8f47bf..8d13c98 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -988,7 +988,6 @@ F:	drivers/platform/x86/asus-laptop.c
 
 ASYNCHRONOUS TRANSFERS/TRANSFORMS (IOAT) API
 M:	Dan Williams <dan.j.williams@intel.com>
-M:	Maciej Sosnowski <maciej.sosnowski@intel.com>
 W:	http://sourceforge.net/projects/xscaleiop
 S:	Supported
 F:	Documentation/crypto/async-tx-api.txt
@@ -1825,7 +1824,6 @@ S:	Supported
 F:	fs/dlm/
 
 DMA GENERIC OFFLOAD ENGINE SUBSYSTEM
-M:	Maciej Sosnowski <maciej.sosnowski@intel.com>
 M:	Dan Williams <dan.j.williams@intel.com>
 S:	Supported
 F:	drivers/dma/
@@ -2788,7 +2786,7 @@ F:	arch/x86/kernel/microcode_core.c
 F:	arch/x86/kernel/microcode_intel.c
 
 INTEL I/OAT DMA DRIVER
-M:	Maciej Sosnowski <maciej.sosnowski@intel.com>
+M:	Dan Williams <dan.j.williams@intel.com>
 S:	Supported
 F:	drivers/dma/ioat*
 

