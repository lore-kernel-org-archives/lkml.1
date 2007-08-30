Return-Path: <linux-kernel-owner+w=401wt.eu-S933040AbXH3Sf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040AbXH3Sf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 14:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932393AbXH3SfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 14:35:15 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:38780
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932350AbXH3SfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 14:35:13 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: linux-arm-kernel@lists.arm.linux.org.uk
Subject: [PATCH] Documentation/arm/00-INDEX add missing entries.
Date: Thu, 30 Aug 2007 14:35:12 -0500
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708301435.13071.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rob Landley <rob@landley.net>

Index two unindexed documentation files.

--- linux-2.6.23-rc4/Documentation/arm/00-INDEX	2007-08-27 20:32:35.000000000 -0500
+++ linux-new/Documentation/arm/00-INDEX	2007-08-30 14:27:15.000000000 -0500
@@ -20,3 +20,7 @@
 	- description of the virtual memory layout
 nwfpe
 	- NWFPE floating point emulator documentation
+Porting
+	- Symbol definitions for porting Linux to a new ARM machine.
+Setup
+	- Kernel initialization parameters on ARM Linux

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
