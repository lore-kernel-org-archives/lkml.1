Return-Path: <linux-kernel-owner+w=401wt.eu-S1751895AbZK2NLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbZK2NLY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 08:11:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbZK2NLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 08:11:24 -0500
Received: from jester.euphonynet.be ([212.87.96.13]:33480 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbZK2NLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 08:11:23 -0500
X-Greylist: delayed 1207 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Nov 2009 08:11:23 EST
From: Bart Van Assche <bart.vanassche@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH] Documentation: Fix a stale reference in Documentation/DMA-API.txt
Date: Sun, 29 Nov 2009 13:51:14 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.30.9-scst-debug; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200911291351.15015.bart.vanassche@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes a stale reference in Documentation/DMA-API.txt.

Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org

diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
index 5aceb88..51b4ca1 100644
--- a/Documentation/DMA-API.txt
+++ b/Documentation/DMA-API.txt
@@ -5,7 +5,7 @@
 
 This document describes the DMA API.  For a more gentle introduction
 phrased in terms of the pci_ equivalents (and actual examples) see
-Documentation/PCI/PCI-DMA-mapping.txt.
+Documentation/DMA-mapping.txt.
 
 This API is split into two pieces.  Part I describes the API and the
 corresponding pci_ API.  Part II describes the extensions to the API
