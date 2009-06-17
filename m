Return-Path: <linux-kernel-owner+w=401wt.eu-S1756714AbZFQQGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714AbZFQQGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754683AbZFQQGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:06:14 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:11567
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753425AbZFQQGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:06:14 -0400
From: Boaz Harrosh <bharrosh@panasas.com>
To: Jeff Garzik <jeff@garzik.org>, open-osd <osd-dev@open-osd.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/6] MAINTAINERS: Add osd maintained files (F:)
Date: Wed, 17 Jun 2009 19:06:14 +0300
Message-Id: <1245254774-8668-1-git-send-email-bharrosh@panasas.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <4A391373.3050301@panasas.com>
References: <4A391373.3050301@panasas.com>
X-OriginalArrivalTime: 17 Jun 2009 16:06:16.0759 (UTC) FILETIME=[8B7ADC70:01C9EF65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OSD files are found in three places:
drivers/scsi/osd/
include/scsi/osd_*
fs/exofs/

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 MAINTAINERS |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fb94add..f42cd7a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4331,6 +4331,9 @@ L:	osd-dev@open-osd.org
 W:	http://open-osd.org
 T:	git git://git.open-osd.org/open-osd.git
 S:	Maintained
+F:	drivers/scsi/osd/
+F:	drivers/include/scsi/osd_*
+F:	fs/exofs/
 
 P54 WIRELESS DRIVER
 P:	Michael Wu
-- 
1.6.2.1

