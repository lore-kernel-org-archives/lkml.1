Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbZILPIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbZILPIo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 11:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbZILPIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 11:08:43 -0400
Received: from smtp.nokia.com ([192.100.105.134]:51898 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbZILPIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 11:08:43 -0400
From: Tiago Vignatti <tiago.vignatti@nokia.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "dri-devel@lists.sf.net" <dri-devel@lists.sf.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Tiago Vignatti <tiago.vignatti@nokia.com>
Subject: [PATCH] PCI/VGA: fix header commentary
Date: Sat, 12 Sep 2009 18:02:31 +0300
Message-Id: <1252767751-27914-1-git-send-email-tiago.vignatti@nokia.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20090817103733.6b525fb4@jbarnes-g45>
References: <20090817103733.6b525fb4@jbarnes-g45>
X-OriginalArrivalTime: 12 Sep 2009 15:06:05.0315 (UTC) FILETIME=[8CD47D30:01CA33BA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tiago Vignatti <tiago.vignatti@nokia.com>
---

Amend this somewhere, Jesse. Thanks.


 include/linux/vgaarb.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/vgaarb.h b/include/linux/vgaarb.h
index e81c64a..290409c 100644
--- a/include/linux/vgaarb.h
+++ b/include/linux/vgaarb.h
@@ -1,5 +1,5 @@
 /*
- * vgaarb.c
+ * vgaarb.h
  *
  * (C) Copyright 2005 Benjamin Herrenschmidt <benh@kernel.crashing.org>
  * (C) Copyright 2007 Paulo R. Zanoni <przanoni@gmail.com>
-- 
1.5.6.3

