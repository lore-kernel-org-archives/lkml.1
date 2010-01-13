Return-Path: <linux-kernel-owner+w=401wt.eu-S1756553Ab0AMV4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab0AMV4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 16:56:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756539Ab0AMV4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 16:56:11 -0500
Received: from mail.perches.com ([173.55.12.10]:1136 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756528Ab0AMV4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 16:56:09 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] MAINTAINERS: WAVELAN moved to staging
Date: Wed, 13 Jan 2010 13:56:07 -0800
Message-Id: <cf79123d4ab783c8cf2030d9a07ec89a9a14fd00.1263419518.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1263419518.git.joe@perches.com>
References: <cover.1263419518.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

by commit 0234f84ebb00d36c48062befa5436eef36b71ccd
Update patterns

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 80520a3..502a5a2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5922,7 +5922,7 @@ L:	linux-wireless@vger.kernel.org
 W:	http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/
 S:	Maintained
 F:	Documentation/networking/wavelan.txt
-F:	drivers/net/wireless/wavelan*
+F:	drivers/staging/wavelan/
 
 WD7000 SCSI DRIVER
 M:	Miroslav Zagorac <zaga@fly.cc.fer.hr>
-- 
1.6.6.rc0.57.gad7a

