Return-Path: <linux-kernel-owner+w=401wt.eu-S932795AbYCEArT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795AbYCEArT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 19:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761546AbYCEAqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 19:46:36 -0500
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2482 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760941AbYCEAqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 19:46:35 -0500
Subject: [PATCH] drivers/scsi/aic94xx/aic94xx_dump.c - use angle brackets
	for include
From: Joe Perches <joe@perches.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 16:46:09 -0800
Message-Id: <1204677969.5180.89.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.1mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>

drivers/scsi/aic94xx/aic94xx_dump.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_dump.c b/drivers/scsi/aic94xx/aic94xx_dump.c
index 3d8c4ff..4209220 100644
--- a/drivers/scsi/aic94xx/aic94xx_dump.c
+++ b/drivers/scsi/aic94xx/aic94xx_dump.c
@@ -29,7 +29,7 @@
  *
  */
 
-#include "linux/pci.h"
+#include <linux/pci.h>
 #include "aic94xx.h"
 #include "aic94xx_reg.h"
 #include "aic94xx_reg_def.h"


