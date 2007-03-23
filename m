Return-Path: <linux-kernel-owner+w=401wt.eu-S933793AbXCWGvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933793AbXCWGvw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 02:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933812AbXCWGvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 02:51:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:22072 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933798AbXCWGvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 02:51:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,317,1170662400"; 
   d="scan'208"; a="62774540:sNHT16788717"
From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2.6.21-rc4 02/15] ARM: Add drivers/dma to arch/arm/Kconfig
To: neilb@suse.de, christopher.leech@intel.com, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, yur@emcraft.com,
       wd@denx.de, arjan@linux.intel.com, rmk+kernel@arm.linux.org.uk
Date: Thu, 22 Mar 2007 23:51:47 -0700
Message-ID: <20070323065147.15570.56413.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20070323064856.15570.45052.stgit@dwillia2-linux.ch.intel.com>
References: <20070323064856.15570.45052.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 arch/arm/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index e7baca2..74077e3 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -997,6 +997,8 @@ source "drivers/mmc/Kconfig"
 
 source "drivers/rtc/Kconfig"
 
+source "drivers/dma/Kconfig"
+
 endmenu
 
 source "fs/Kconfig"
