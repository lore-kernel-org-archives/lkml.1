Return-Path: <linux-kernel-owner+w=401wt.eu-S2992788AbXEBGQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992788AbXEBGQ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 02:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161744AbXEBGQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 02:16:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:8602 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161730AbXEBGQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 02:16:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,477,1170662400"; 
   d="scan'208";a="237749849"
From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 03/16] ARM: Add drivers/dma to arch/arm/Kconfig
To: neilb@suse.de, akpm@linux-foundation.org, christopher.leech@intel.com
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Date: Tue, 01 May 2007 23:16:10 -0700
Message-ID: <20070502061610.7066.25982.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20070502060949.7066.357.stgit@dwillia2-linux.ch.intel.com>
References: <20070502060949.7066.357.stgit@dwillia2-linux.ch.intel.com>
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
index e7baca2..74077e3 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -997,6 +997,8 @@ source "drivers/mmc/Kconfig"
 
 source "drivers/rtc/Kconfig"
 
+source "drivers/dma/Kconfig"
+
 endmenu
 
 source "fs/Kconfig"
