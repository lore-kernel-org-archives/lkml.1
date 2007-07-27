Return-Path: <linux-kernel-owner+w=401wt.eu-S937054AbXG0Kne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937054AbXG0Kne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 06:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934393AbXG0KnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 06:43:17 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:5101 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933973AbXG0KnQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 06:43:16 -0400
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, general@lists.openfabrics.org
Subject: [PATCH 2/2] ehca: correction include order according kernel coding style
Date: Fri, 27 Jul 2007 12:55:19 +0200
User-Agent: KMail/1.8.2
Cc: raisch@de.ibm.com, stefan.roscher@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707271255.19456.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From a2794450cbee597cefd7b6e159257583c459d358 Mon Sep 17 00:00:00 2001
From: Hoang-Nam Nguyen <hnguyen at de.ibm.com>
Date: Fri, 27 Jul 2007 10:26:40 +0200
Subject: [PATCH] correction include order according kernel coding style

Signed-off-by: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_mrmw.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_mrmw.c b/drivers/infiniband/hw/ehca/ehca_mrmw.c
index 773ac3f..1180b65 100644
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c
+++ b/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -40,9 +40,8 @@
  * POSSIBILITY OF SUCH DAMAGE.
  */
 
-#include <rdma/ib_umem.h>
-
 #include <asm/current.h>
+#include <rdma/ib_umem.h>
 
 #include "ehca_iverbs.h"
 #include "ehca_mrmw.h"
-- 
1.5.2


