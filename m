Return-Path: <linux-kernel-owner+w=401wt.eu-S1751668AbZLIFP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668AbZLIFP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 00:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750856AbZLIFP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 00:15:26 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51583 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750832AbZLIFP0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 00:15:26 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 09 Dec 2009 05:15:29 +0000
Message-ID: <1260335729.4532.245.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 1/5] firmware/WHENCE: Update filenames for bnx2
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The firmware was updated but WHENCE was not.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 firmware/WHENCE |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/firmware/WHENCE b/firmware/WHENCE
index 34b5d0a..5fe6045 100644
--- a/firmware/WHENCE
+++ b/firmware/WHENCE
@@ -698,10 +698,11 @@ Found in hex form in kernel source.
 
 Driver: BNX2 - Broadcom NetXtremeII
 
-File: bnx2/bnx2-mips-06-4.6.16.fw
-File: bnx2/bnx2-rv2p-06-4.6.16.fw
-File: bnx2/bnx2-mips-09-4.6.17.fw
-File: bnx2/bnx2-rv2p-09-4.6.15.fw
+File: bnx2/bnx2-mips-06-5.0.0.j3.fw
+File: bnx2/bnx2-rv2p-06-5.0.0.j3.fw
+File: bnx2/bnx2-mips-09-5.0.0.j3.fw
+File: bnx2/bnx2-rv2p-09-5.0.0.j3.fw
+File: bnx2/bnx2-rv2p-09ax-5.0.0.j3.fw
 
 Licence:
 
-- 
1.6.5.3



