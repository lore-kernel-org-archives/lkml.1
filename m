Return-Path: <linux-kernel-owner+w=401wt.eu-S1765259AbXGPPXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765259AbXGPPXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 11:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759424AbXGPPXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 11:23:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759598AbXGPPXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 11:23:08 -0400
Date: Mon, 16 Jul 2007 11:23:03 -0400
From: Dave Jones <davej@redhat.com>
To: jgarzik@pobox.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Correct comment in libata-sff.c
Message-ID: <20070716152303.GA13788@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, jgarzik@pobox.com,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The filename in the file header is incorrect.

Signed-off-by: Dave Jones <davej@redhat.com>

--- linux-2.6.22.noarch/drivers/ata/libata-sff.c~	2007-07-16 11:21:37.000000000 -0400
+++ linux-2.6.22.noarch/drivers/ata/libata-sff.c	2007-07-16 11:21:46.000000000 -0400
@@ -1,5 +1,5 @@
 /*
- *  libata-bmdma.c - helper library for PCI IDE BMDMA
+ *  libata-sff.c - helper library for PCI IDE BMDMA
  *
  *  Maintained by:  Jeff Garzik <jgarzik@pobox.com>
  *    		    Please ALWAYS copy linux-ide@vger.kernel.org


-- 
http://www.codemonkey.org.uk
