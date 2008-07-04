Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173AbYGDSzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbYGDSzv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 14:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbYGDSzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 14:55:43 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:50064 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbYGDSzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 14:55:42 -0400
X-BigFish: VPS22(zzzz10d3izzz32i87il64h)
X-Spam-TCS-SCL: 3:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3HWK9-02-CFC-01
From: Robert Richter <robert.richter@amd.com>
To: oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
CC: Robert Richter <robert.richter@amd.com>,
       Philippe Elie <phil.el@wanadoo.fr>,
       John Levon <levon@movementarian.org>,
       Maynard Johnson <maynardj@us.ibm.com>,
       Richard Purdie <rpurdie@openedhand.com>,
       Daniel Hansel <daniel.hansel@linux.vnet.ibm.com>,
       Jason Yeh <jason.yeh@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] OProfile kernel maintainership changes
Date: Fri, 4 Jul 2008 20:53:39 +0200
Message-ID: <1215197619-28982-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
X-OriginalArrivalTime: 04 Jul 2008 18:55:28.0729 (UTC) FILETIME=[86C58C90:01C8DE07]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Philippe Elie <phil.el@wanadoo.fr>
Cc: John Levon <levon@movementarian.org>
Cc: Maynard Johnson <maynardj@us.ibm.com>
Cc: Richard Purdie <rpurdie@openedhand.com>
Cc: Daniel Hansel <daniel.hansel@linux.vnet.ibm.com>
Cc: Jason Yeh <jason.yeh@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 MAINTAINERS |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e6c06fa..85a7e4a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3080,8 +3080,8 @@ L:	linux-scsi@vger.kernel.org
 S:	Maintained
 
 OPROFILE
-P:	Philippe Elie
-M:	phil.el@wanadoo.fr
+P:	Robert Richter
+M:	robert.richter@amd.com
 L:	oprofile-list@lists.sf.net
 S:	Maintained
 
-- 
1.5.5.4


