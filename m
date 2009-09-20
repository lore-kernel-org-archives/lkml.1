Return-Path: <linux-kernel-owner+w=401wt.eu-S1753052AbZITOWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbZITOWu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 10:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbZITOWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 10:22:49 -0400
Received: from khc.piap.pl ([195.187.100.11]:60969 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237AbZITOWt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 10:22:49 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: <linux-kernel@vger.kernel.org>
Cc: trivial@kernel.org
Subject: [PATCH][TRIVIAL] Fix comment in drivers/ata/pata_hpt37x.c.
Date: Sun, 20 Sep 2009 16:22:51 +0200
Message-ID: <m3zl8p3dc4.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A comment fix in drivers/ata/pata_hpt37x.c.

Signed-off-by: Krzysztof Ha³asa <khc@pm.waw.pl>

diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index 122c786..d0a7df2 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -624,7 +624,7 @@ static struct ata_port_operations hpt374_fn1_port_ops = {
 };
 
 /**
- *	htp37x_clock_slot	-	Turn timing to PC clock entry
+ *	hpt37x_clock_slot	-	Turn timing to PC clock entry
  *	@freq: Reported frequency timing
  *	@base: Base timing
  *
