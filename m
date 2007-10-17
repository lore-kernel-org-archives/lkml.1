Return-Path: <linux-kernel-owner+w=401wt.eu-S933604AbXJQUSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933604AbXJQUSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 16:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbXJQUSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 16:18:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759554AbXJQUSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:18:35 -0400
Date: Wed, 17 Oct 2007 16:18:30 -0400
From: Dave Jones <davej@redhat.com>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: fix typo in mtd kconfig
Message-ID: <20071017201830.GA24845@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Jones <davej@redhat.com>

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

-- 
http://www.codemonkey.org.uk
