Return-Path: <linux-kernel-owner+w=401wt.eu-S1752730AbXJADXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbXJADXS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 23:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750931AbXJADXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 23:23:08 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:55167
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750947AbXJADXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 23:23:06 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: linux-arm-kernel@lists.arm.linux.org.uk
Subject: [PATCH] Add missing entries to Documentation/arm/00-INDEX
Date: Sun, 30 Sep 2007 22:23:01 -0500
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709302223.01788.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>

Add several missing entries to Documentation/arm/00-INDEX

Signed-off-by: Rob Landley <rob@landley.net>
---

 Documentation/arm/00-INDEX |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff -r f4ca99897c12 Documentation/arm/00-INDEX
--- a/Documentation/arm/00-INDEX	Sat Sep 29 10:00:15 2007 -0700
+++ b/Documentation/arm/00-INDEX	Sun Sep 30 22:16:06 2007 -0500
@@ -4,19 +4,29 @@ Booting
 	- requirements for booting
 Interrupts
 	- ARM Interrupt subsystem documentation
+IXP2000
+	- Release Notes for Linux on Intel's IXP2000 Network Processor
 Netwinder
 	- Netwinder specific documentation
+Porting
+       - Symbol definitions for porting Linux to a new ARM machine.
+Setup
+       - Kernel initialization parameters on ARM Linux
 README
 	- General ARM documentation
-SA1100
+SA1100/
 	- SA1100 documentation
-XScale
-	- XScale documentation
-empeg
-	- Empeg documentation
+Samsung-S3C24XX
+	- S3C24XX ARM Linux Overview
+Sharp-LH
+	- Linux on Sharp LH79524 and LH7A40X System On a Chip (SOC)
+VFP/
+	- Release notes for Linux Kernel Vector Floating Point support code
+empeg/
+	- Ltd's Empeg MP3 Car Audio Player
 mem_alignment
 	- alignment abort handler documentation
 memory.txt
 	- description of the virtual memory layout
-nwfpe
+nwfpe/
 	- NWFPE floating point emulator documentation

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
