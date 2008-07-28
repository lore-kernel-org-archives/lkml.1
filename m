Return-Path: <linux-kernel-owner+w=401wt.eu-S1759399AbYG1Qsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759399AbYG1Qsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 12:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757295AbYG1Qqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 12:46:50 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:33444 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbYG1Qqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 12:46:44 -0400
X-BigFish: VPS-10(zz4015M936fQzz10d3izzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K4Q6LC-01-PPP-01
Message-ID: <20080728164411.490752571@amd.com>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Mon, 28 Jul 2008 18:44:11 +0200
From: Peter Oruba <peter.oruba@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [patch 00/11] x86: AMD microcode patch loading support v2
X-OriginalArrivalTime: 28 Jul 2008 16:46:29.0090 (UTC) FILETIME=[7B805C20:01C8F0D1]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AMD microcode patch loader v2, rebased to Linux master.

Thanks,
Peter Oruba
>From peter.oruba@amd.com Mon Jul 28 18:44:47 2008
Message-Id: <20080728164447.259144113@amd.com>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Mon, 28 Jul 2008 18:44:12 +0200
From: Peter Oruba <peter.oruba@amd.com>
To: Ingo Molnar <mingo@elte.hu>,
 Thomas Gleixner <tglx@linutronix.de>,
 Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
 Peter Oruba <peter.oruba@amd.com>
Bcc: osrc-patches@elbe.amd.com
Subject: [patch 01/11] [PATCH 01/11] x86: Add entry to MAINTAINERS file
References: <20080728164411.490752571@amd.com>
Content-Disposition: inline; filename=0001-x86-Add-entry-to-MAINTAINERS-file.patch

Add an entry to the MAINTAINERS file for AMD CPU microcode
patch loading support.

Signed-off-by: Peter Oruba <peter.oruba@amd.com>
---
 MAINTAINERS |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 03c5d6c..28f867d 100644
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




