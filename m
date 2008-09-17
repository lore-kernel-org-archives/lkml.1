Return-Path: <linux-kernel-owner+w=401wt.eu-S1756322AbYIQQzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322AbYIQQzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 12:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755159AbYIQQxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 12:53:17 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:4277 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506AbYIQQxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:53:14 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0K7CMWD-04-US7-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org
CC: iommu@lists.linux-foundation.org, Joerg Roedel <jroedel@lemmy.amd.com>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 23/23] add AMD IOMMU tree to MAINTAINERS file
Date: Wed, 17 Sep 2008 18:52:57 +0200
Message-ID: <1221670377-19295-24-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
References: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 17 Sep 2008 16:52:58.0245 (UTC) FILETIME=[D685F350:01C918E5]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@lemmy.amd.com>

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 38713f9..a649ea5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -387,6 +387,7 @@ AMD IOMMU (AMD-VI)
 P:	Joerg Roedel
 M:	joerg.roedel@amd.com
 L:	iommu@lists.linux-foundation.org
+T:	git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git
 S:	Supported
 
 AMD MICROCODE UPDATE SUPPORT
-- 
1.5.6.4


