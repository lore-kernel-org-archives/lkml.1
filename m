Return-Path: <linux-kernel-owner+w=401wt.eu-S1760955AbXF0B6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760955AbXF0B6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 21:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757857AbXF0BwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 21:52:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:51733 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754369AbXF0BwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 21:52:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,465,1175497200"; 
   d="scan'208";a="261537720"
From: Dan Williams <dan.j.williams@intel.com>
Subject: [md-accel PATCH 19/19] ARM: Add drivers/dma to arch/arm/Kconfig
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: neilb@suse.de, akpm@linux-foundation.org, davem@davemloft.net,
       christopher.leech@intel.com, shannon.nelson@intel.com,
       herbert@gondor.apana.org.au, jeff@garzik.org
Date: Tue, 26 Jun 2007 18:52:10 -0700
Message-ID: <20070627015210.18962.99133.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
References: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 arch/arm/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 50d9f3e..0cb2d4f 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1034,6 +1034,8 @@ source "drivers/mmc/Kconfig"
 
 source "drivers/rtc/Kconfig"
 
+source "drivers/dma/Kconfig"
+
 endmenu
 
 source "fs/Kconfig"
