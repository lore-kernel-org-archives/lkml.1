Return-Path: <linux-kernel-owner+w=401wt.eu-S1751050AbZLIFQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751050AbZLIFQB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 00:16:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264AbZLIFPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 00:15:54 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51591 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751042AbZLIFPw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 00:15:52 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 09 Dec 2009 05:15:56 +0000
Message-ID: <1260335756.4532.247.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 3/5] firmware/WHENCE: Use 'File:' field name in front of
 each file name
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will aid automatic parsing of this file.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 firmware/WHENCE |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/firmware/WHENCE b/firmware/WHENCE
index e144711..7cee2da 100644
--- a/firmware/WHENCE
+++ b/firmware/WHENCE
@@ -412,7 +412,7 @@ Driver: cxgb3 - Chelsio Terminator 3 1G/10G Ethernet adapter
 
 File: cxgb3/t3b_psram-1.1.0.bin
 File: cxgb3/t3c_psram-1.1.0.bin
-file: cxgb3/t3fw-7.4.0.bin
+File: cxgb3/t3fw-7.4.0.bin
 
 License: GPLv2 or OpenIB.org BSD license, no source visible
 
@@ -596,11 +596,11 @@ Found in hex form in kernel source.
 Driver: PCMCIA_PCNET - NE2000 compatible PCMCIA adapter
 
 File: cis/LA-PCM.cis
-      cis/PCMLM28.cis
-      cis/DP83903.cis
-      cis/NE2K.cis
-      cis/tamarack.cis
-      cis/PE-200.cis
+File: cis/PCMLM28.cis
+File: cis/DP83903.cis
+File: cis/NE2K.cis
+File: cis/tamarack.cis
+File: cis/PE-200.cis
 
 Licence: GPL
 
@@ -631,12 +631,12 @@ Originally developed by the pcmcia-cs project
 Driver: SERIAL_8250_CS - Serial PCMCIA adapter
 
 File: cis/MT5634ZLX.cis
-      cis/RS-COM-2P.cis
-      cis/COMpad2.cis
-      cis/COMpad4.cis
-      cis/SW_555_SER.cis
-      cis/SW_7xx_SER.cis
-      cis/SW_8xx_SER.cis
+File: cis/RS-COM-2P.cis
+File: cis/COMpad2.cis
+File: cis/COMpad4.cis
+File: cis/SW_555_SER.cis
+File: cis/SW_7xx_SER.cis
+File: cis/SW_8xx_SER.cis
 
 Licence: GPL
 
-- 
1.6.5.3



