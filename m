Return-Path: <linux-kernel-owner+w=401wt.eu-S1756181AbZDUPSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbZDUPSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 11:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbZDUPSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 11:18:23 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:44083 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733AbZDUPSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 11:18:22 -0400
From: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       "OF-EWG" <ewg@lists.openfabrics.org>,
       LKML <linux-kernel@vger.kernel.org>, Roland Dreier <rolandd@cisco.com>
Subject: [PATCH 3/3] IB/ehca: Increment version number
Date: Tue, 21 Apr 2009 17:18:16 +0200
User-Agent: KMail/1.9.9
Cc: raisch@de.ibm.com, hnguyen@de.ibm.com, fenkes@de.ibm.com,
       stefan.roscher@de.ibm.com, alexschm@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904211718.16434.ossrosch@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Roscher <stefan.roscher@de.ibm.com>

---
 drivers/infiniband/hw/ehca/ehca_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 368311c..85905ab 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -52,7 +52,7 @@
 #include "ehca_tools.h"
 #include "hcp_if.h"
 
-#define HCAD_VERSION "0026"
+#define HCAD_VERSION "0027"
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Christoph Raisch <raisch@de.ibm.com>");
-- 
1.5.5

