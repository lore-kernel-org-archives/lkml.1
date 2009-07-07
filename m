Return-Path: <linux-kernel-owner+w=401wt.eu-S1758410AbZGGOf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758410AbZGGOf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758136AbZGGOe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:34:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:42690 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758336AbZGGOe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:34:26 -0400
Subject: [PATCH 8/22] trivial: fix typo "can can"
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: trivial <trivial@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1246975428.3613.10.camel@ht.satnam>
References: <1246975428.3613.10.camel@ht.satnam>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 19:43:59 +0530
Message-Id: <1246976039.3613.23.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Replaced "can can" with "can"

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 include/linux/mtd/pfow.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/mtd/pfow.h b/include/linux/mtd/pfow.h
index b730d4f..97df931 100644
--- a/include/linux/mtd/pfow.h
+++ b/include/linux/mtd/pfow.h
@@ -18,7 +18,7 @@
 /* Identification info for LPDDR chip */
 #define PFOW_MANUFACTURER_ID			0x0020
 #define PFOW_DEVICE_ID				0x0022
-/* Address in PFOW where prog buffer can can be found */
+/* Address in PFOW where prog buffer can be found */
 #define PFOW_PROGRAM_BUFFER_OFFSET		0x0040
 /* Size of program buffer in words */
 #define PFOW_PROGRAM_BUFFER_SIZE		0x0042
-- 
1.6.0.6



