Return-Path: <linux-kernel-owner+w=401wt.eu-S933204AbYEIRb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933204AbYEIRb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 13:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761776AbYEIRbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 13:31:49 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:39275 "EHLO
	pd4mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759946AbYEIRbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 13:31:49 -0400
Date: Fri, 09 May 2008 11:29:58 -0600
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] mpc5200_psc_spi: Typo fix in header block
To: linux-kernel@vger.kernel.org, dragos.carp@toptica.com,
       spi-devel-general@lists.sourceforge.net
Message-id: <20080509172958.2795.23732.stgit@trillian.secretlab.ca>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
User-Agent: StGIT/0.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 drivers/spi/mpc52xx_psc_spi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/mpc52xx_psc_spi.c b/drivers/spi/mpc52xx_psc_spi.c
index 9072946..681d623 100644
--- a/drivers/spi/mpc52xx_psc_spi.c
+++ b/drivers/spi/mpc52xx_psc_spi.c
@@ -1,5 +1,5 @@
 /*
- * MPC52xx SPC in SPI mode driver.
+ * MPC52xx PSC in SPI mode driver.
  *
  * Maintainer: Dragos Carp
  *

