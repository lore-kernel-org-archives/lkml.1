Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935913Ab0B0Va0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 16:30:26 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56287 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935829Ab0B0VaW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 16:30:22 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1267306076.16186.103.camel@localhost>
References: <1267306076.16186.103.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 27 Feb 2010 21:30:19 +0000
Message-ID: <1267306219.16186.105.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH firmware 2/6] Use 'File:' field name in front of each
 filename
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will aid automatic parsing of this file.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 WHENCE |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/WHENCE b/WHENCE
index 728b71d..c291289 100644
--- a/WHENCE
+++ b/WHENCE
@@ -498,7 +498,7 @@ File: cxgb3/t3b_psram-1.1.0.bin
 File: cxgb3/t3c_psram-1.1.0.bin
 File: cxgb3/t3fw-7.0.0.bin
 File: cxgb3/t3fw-7.1.0.bin
-file: cxgb3/t3fw-7.4.0.bin
+File: cxgb3/t3fw-7.4.0.bin
 
 Licence: GPLv2 or OpenIB.org BSD license, no source visible
 
@@ -774,11 +774,11 @@ Found in hex form in kernel source.
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
 
@@ -809,12 +809,12 @@ Originally developed by the pcmcia-cs project
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
1.6.6.2



