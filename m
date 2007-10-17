Return-Path: <linux-kernel-owner+w=401wt.eu-S1759154AbXJQVh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759154AbXJQVh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 17:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932203AbXJQVhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 17:37:43 -0400
Received: from lazybastard.de ([212.112.238.170]:39796 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762088AbXJQVhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 17:37:42 -0400
Date: Wed, 17 Oct 2007 23:33:12 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
       Dave Jones <davej@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: fix typo in mtd kconfig
Message-ID: <20071017213311.GB14633@lazybastard.org>
References: <20071017201830.GA24845@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071017201830.GA24845@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David, will you take this patch?

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Joern Engel <joern@logfs.org>

diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 8f9c3ba..246d451 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -300,7 +300,7 @@ config MTD_NAND_PLATFORM
 	  via platform_data.
 
 config MTD_ALAUDA
-	tristate "MTD driver for Olympus MAUSB-10 and Fijufilm DPC-R1"
+	tristate "MTD driver for Olympus MAUSB-10 and Fujifilm DPC-R1"
 	depends on MTD_NAND && USB
 	help
 	  These two (and possibly other) Alauda-based cardreaders for


Jörn

-- 
It does not matter how slowly you go, so long as you do not stop.
-- Confucius
