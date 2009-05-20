Return-Path: <linux-kernel-owner+w=401wt.eu-S1758508AbZETSox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758508AbZETSox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 14:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757415AbZETSoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 14:44:16 -0400
Received: from sg2ehsobe001.messaging.microsoft.com ([207.46.51.75]:47942 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757308AbZETSoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 14:44:15 -0400
X-BigFish: VPS1(zzzz1202hzzz32i66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KJYHD6-02-V45-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <akpm@linux-foundation.org>, <greg@kroah.com>, <mingo@elte.hu>
CC: <norsk5@yahoo.com>, <tglx@linutronix.de>, <hpa@zytor.com>,
       <mchehab@redhat.com>, <aris@redhat.com>, edt@aei.ca,
       <linux-kernel@vger.kernel.org>, randy.dunlap@oracle.com,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 4/4] amd64_edac: add MAINTAINERS entry
Date: Wed, 20 May 2009 20:43:57 +0200
Message-ID: <1242845037-1029-5-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1242845037-1029-1-git-send-email-borislav.petkov@amd.com>
References: <1242845037-1029-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 20 May 2009 18:44:00.0684 (UTC) FILETIME=[F0DA36C0:01C9D97A]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Doug Thompson <norsk5@yahoo.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 MAINTAINERS |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2b349ba..1b93ae4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1961,6 +1961,16 @@ F:	Documentation/edac.txt
 F:	drivers/edac/edac_*
 F:	include/linux/edac.h
 
+EDAC-AMD64
+P:	Doug Thompson
+M:	dougthompson@xmission.com
+P:	Borislav Petkov
+M:	borislav.petkov@amd.com
+L:	bluesmoke-devel@lists.sourceforge.net (moderated for non-subscribers)
+W:	bluesmoke.sourceforge.net
+S:	Supported
+F:	drivers/edac/amd64_edac*
+
 EDAC-E752X
 P:	Mark Gross
 P:	Doug Thompson
-- 
1.6.2.4


