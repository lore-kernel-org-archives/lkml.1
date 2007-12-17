Return-Path: <linux-kernel-owner+w=401wt.eu-S1764949AbXLQTrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764949AbXLQTrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:47:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758521AbXLQTcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:32:06 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3028 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761175AbXLQTb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:31:59 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Raisch <raisch@de.ibm.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>,
       Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
       Roland Dreier <rolandd@cisco.com>,
       Sean Hefty <mshefty@ichips.intel.com>, general@lists.openfabrics.org
Subject: [PATCH] drivers/infiniband/: Spelling fixes
Date: Mon, 17 Dec 2007 11:30:36 -0800
Message-Id: <1197919875-5288-37-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918891.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/infiniband/hw/cxgb3/cxio_hal.c |    2 +-
 drivers/infiniband/hw/ehca/ehca_av.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.c b/drivers/infiniband/hw/cxgb3/cxio_hal.c
index eec6a30..26b8c0e 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_hal.c
+++ b/drivers/infiniband/hw/cxgb3/cxio_hal.c
@@ -584,7 +584,7 @@ static int cxio_hal_ctrl_qp_write_mem(struct cxio_rdev *rdev_p, u32 addr,
 {
 	u32 i, nr_wqe, copy_len;
 	u8 *copy_data;
-	u8 wr_len, utx_len;	/* lenght in 8 byte flit */
+	u8 wr_len, utx_len;	/* length in 8 byte flit */
 	enum t3_wr_flags flag;
 	__be64 *wqe;
 	u64 utx_cmd;
diff --git a/drivers/infiniband/hw/ehca/ehca_av.c b/drivers/infiniband/hw/ehca/ehca_av.c
index f7782c8..194c1c3 100644
--- a/drivers/infiniband/hw/ehca/ehca_av.c
+++ b/drivers/infiniband/hw/ehca/ehca_av.c
@@ -1,7 +1,7 @@
 /*
  *  IBM eServer eHCA Infiniband device driver for Linux on POWER
  *
- *  adress vector functions
+ *  address vector functions
  *
  *  Authors: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
  *           Khadija Souissi <souissik@de.ibm.com>
-- 
1.5.3.7.949.g2221a6

