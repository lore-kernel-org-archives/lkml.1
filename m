Return-Path: <linux-kernel-owner+w=401wt.eu-S1762735AbYFZTew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762735AbYFZTew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756185AbYFZT3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:29:04 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:4096 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761280AbYFZT3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:29:01 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0K334RU-04-UON-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 33/34] AMD IOMMU: add MAINTAINERS entry
Date: Thu, 26 Jun 2008 21:28:09 +0200
Message-ID: <1214508490-29683-34-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 26 Jun 2008 19:28:12.0299 (UTC) FILETIME=[C5D88DB0:01C8D7C2]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an entry to the MAINTAINERS file for AMD IOMMU.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8f0ec46..5e89cea 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -376,6 +376,12 @@ L:	linux-geode@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.amd.com/us-en/ConnectivitySolutions/TechnicalResources/0,,50_2334_2452_11363,00.html
 S:	Supported
 
+AMD IOMMU (AMD-VI)
+P:	Joerg Roedel
+M:	joerg.roedel@amd.com
+L:	iommu@lists.linux-foundation.org
+S:	Supported
+
 AMS (Apple Motion Sensor) DRIVER
 P:	Stelian Pop
 M:	stelian@popies.net
-- 
1.5.3.7


