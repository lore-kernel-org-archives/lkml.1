Return-Path: <linux-kernel-owner+w=401wt.eu-S1758434AbZGGOep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434AbZGGOep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758258AbZGGOeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:34:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:42683 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758250AbZGGOeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:34:14 -0400
Subject: [PATCH 7/22] trivial: fix typo "by by" in multiple files
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: trivial <trivial@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1246975428.3613.10.camel@ht.satnam>
References: <1246975428.3613.10.camel@ht.satnam>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 19:42:33 +0530
Message-Id: <1246975953.3613.21.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Replaced "by by" with "by" in multiple files

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/media/video/ov511.c            |    2 +-
 drivers/media/video/ovcamchip/ov7x10.c |    2 +-
 include/linux/ipv6.h                   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/ov511.c b/drivers/media/video/ov511.c
index 0bc2cf5..118de90 100644
--- a/drivers/media/video/ov511.c
+++ b/drivers/media/video/ov511.c
@@ -4,7 +4,7 @@
  * Copyright (c) 1999-2003 Mark W. McClelland
  * Original decompression code Copyright 1998-2000 OmniVision Technologies
  * Many improvements by Bret Wallach <bwallac1@san.rr.com>
- * Color fixes by by Orion Sky Lawlor <olawlor@acm.org> (2/26/2000)
+ * Color fixes by Orion Sky Lawlor <olawlor@acm.org> (2/26/2000)
  * Snapshot code by Kevin Moore
  * OV7620 fixes by Charl P. Botha <cpbotha@ieee.org>
  * Changes by Claudio Matsuoka <claudio@conectiva.com>
diff --git a/drivers/media/video/ovcamchip/ov7x10.c b/drivers/media/video/ovcamchip/ov7x10.c
index 5206e79..3d48820 100644
--- a/drivers/media/video/ovcamchip/ov7x10.c
+++ b/drivers/media/video/ovcamchip/ov7x10.c
@@ -3,7 +3,7 @@
  * Copyright (c) 1999-2004 Mark McClelland <mark@alpha.dyndns.org>
  * http://alpha.dyndns.org/ov511/
  *
- * Color fixes by by Orion Sky Lawlor <olawlor@acm.org> (2/26/2000)
+ * Color fixes by Orion Sky Lawlor <olawlor@acm.org> (2/26/2000)
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index c662efa..cf7d7cf 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -296,7 +296,7 @@ struct ipv6_pinfo {
 
 	/*
 	 * Packed in 16bits.
-	 * Omit one shift by by putting the signed field at MSB.
+	 * Omit one shift by putting the signed field at MSB.
 	 */
 #if defined(__BIG_ENDIAN_BITFIELD)
 	__s16			hop_limit:9;
-- 
1.6.0.6



