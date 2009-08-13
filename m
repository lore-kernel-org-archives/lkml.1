Return-Path: <linux-kernel-owner+w=401wt.eu-S1754131AbZHMKBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbZHMKBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 06:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbZHMKBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 06:01:49 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:45526 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754054AbZHMKBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 06:01:48 -0400
Message-Id: <20090813100638.279654771@fluff.org>
References: <20090813100602.545180197@fluff.org>
User-Agent: quilt/0.46-1
Date: Thu, 13 Aug 2009 11:06:03 +0100
From: Ben Dooks <ben@simtec.co.uk>
To: spi-devel-general@lists.sourceforge.net, dbrownell@users.sourceforge.ne
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 1/7] spi: fix spelling of automatically in documentation
Content-Disposition: inline; filename=spi-fix-spello1.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix spelling of automatically in Documentation/spi/spi-summary.

Signed-off-by: Ben Dooks <ben@simtec.co.uk>

---
 Documentation/spi/spi-summary |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/Documentation/spi/spi-summary
===================================================================
--- a/Documentation/spi/spi-summary	2009-07-09 15:07:37.000000000 +0100
+++ b/Documentation/spi/spi-summary	2009-07-09 15:09:41.000000000 +0100
@@ -350,7 +350,7 @@ SPI protocol drivers somewhat resemble p
 		.resume		= CHIP_resume,
 	};
 
-The driver core will autmatically attempt to bind this driver to any SPI
+The driver core will automatically attempt to bind this driver to any SPI
 device whose board_info gave a modalias of "CHIP".  Your probe() code
 might look like this unless you're creating a device which is managing
 a bus (appearing under /sys/class/spi_master).

-- 
