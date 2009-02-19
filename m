Return-Path: <linux-kernel-owner+w=401wt.eu-S1759634AbZBSNvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759634AbZBSNvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 08:51:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756313AbZBSNrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 08:47:40 -0500
Received: from ti-out-0910.google.com ([209.85.142.184]:50627 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756720AbZBSNrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 08:47:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=MliOkdSXS7OTbNbwJZ4nbEPu1I2Qqp9JnbVmZZfDwv0xP/co48d2D6/SFxt4nbkVlR
         +xqUYhjTsGSBJoS1PADTOCeqSkWMAiGjCroAAq35aKHVMi0BtvBY7l1QGsptm7aYXtzj
         e44rd6bHjXPaTKWJLMJbUdy1FVHdeGWpa4pLw=
From: Eric Miao <eric.y.miao@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Eric Miao <eric.miao@marvell.com>,
       Jason Chagas <jason.chagas@marvell.com>
Subject: [PATCH] MAINTAINERS: update pxa168 maintainers
Date: Thu, 19 Feb 2009 21:46:01 +0800
Message-Id: <1235051161-8858-13-git-send-email-eric.y.miao@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1235051161-8858-12-git-send-email-eric.y.miao@gmail.com>
References: <1235051161-8858-1-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-2-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-3-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-4-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-5-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-6-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-7-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-8-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-9-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-10-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-11-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-12-git-send-email-eric.y.miao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Miao <eric.miao@marvell.com>

Signed-off-by: Eric Miao <eric.miao@marvell.com>
Cc: Jason Chagas <jason.chagas@marvell.com>
---
 MAINTAINERS |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 799f9d8..a6b44f3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3534,6 +3534,14 @@ M:	linux@arm.linux.org.uk
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
 S:	Maintained
 
+PXA168 SUPPORT
+P:	Eric Miao
+M:	eric.miao@marvell.com
+P:	Jason Chagas
+M:	jason.chagas@marvell.com
+L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+S:	Supported
+
 PXA MMCI DRIVER
 S:	Orphan
 
-- 
1.6.0.4

