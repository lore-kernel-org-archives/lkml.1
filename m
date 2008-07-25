Return-Path: <linux-kernel-owner+w=401wt.eu-S1754262AbYGYQqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbYGYQqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 12:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751757AbYGYQqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 12:46:38 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:56956 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbYGYQqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 12:46:37 -0400
X-BigFish: VPS5(zz1cddkzz10d3izzz32i66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0K4KMKU-02-Q8G-01
Message-ID: <20080725164733.923922160@amd.com>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Fri, 25 Jul 2008 18:44:35 +0200
From: Peter Oruba <peter.oruba@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
CC: LKML <linux-kernel@vger.kernel.org>, Peter Oruba <peter.oruba@amd.com>
Subject: [PATCH] x86: Add entry to MAINTAINERS file
References: <20080725161723.636932280@amd.com>
Content-Disposition: inline;
	filename="0001-x86-Add-entry-to-MAINTAINERS-file.patch"
X-OriginalArrivalTime: 25 Jul 2008 16:46:11.0629 (UTC) FILETIME=[F1DAC5D0:01C8EE75]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an entry to the MAINTAINERS file for AMD CPU microcode
patch loading support.

Signed-off-by: Peter Oruba <peter.oruba@amd.com>
---
 MAINTAINERS |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index df3fa0e..da77c18 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -384,6 +384,11 @@ M:	joerg.roedel@amd.com
 L:	iommu@lists.linux-foundation.org
 S:	Supported
 
+AMD MICROCODE UPDATE SUPPORT
+P:      Peter Oruba
+M:      peter.oruba@amd.com
+S:      Supported
+
 AMS (Apple Motion Sensor) DRIVER
 P:	Stelian Pop
 M:	stelian@popies.net
-- 
1.5.4.5




