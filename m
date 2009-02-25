Return-Path: <linux-kernel-owner+w=401wt.eu-S1762892AbZBYPPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762892AbZBYPPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 10:15:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756829AbZBYPJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 10:09:13 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:58568 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756943AbZBYPIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 10:08:42 -0500
Message-Id: <20090225150836.347754781@de.ibm.com>
References: <20090225150622.529143164@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 25 Feb 2009 16:06:55 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Felix Beck <felix.beck@de.ibm.com>,
       Ralph Wuerthner <ralph.wuerthner@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch/s390 33/46] Add zcrypt section in MAINTAINERS
Content-Disposition: inline; filename=132-zcrypt-maintainer.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felix Beck <felix.beck@de.ibm.com>

Add zcrypt section in S390 part of MAINTAINERS file.

Signed-off-by: Felix Beck <felix.beck@de.ibm.com>
Signed-off-by: Ralph Wuerthner <ralph.wuerthner@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 MAINTAINERS |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: quilt-2.6/MAINTAINERS
===================================================================
--- quilt-2.6.orig/MAINTAINERS
+++ quilt-2.6/MAINTAINERS
@@ -3730,6 +3730,15 @@ L:	linux-s390@vger.kernel.org
 W:	http://www.ibm.com/developerworks/linux/linux390/
 S:	Supported
 
+S390 ZCRYPT DRIVER
+P:	Felix Beck
+M:	felix.beck@de.ibm.com
+P:	Ralph Wuerthner
+M:	ralph.wuerthner@de.ibm.com
+M:	linux390@de.ibm.com
+L:	linux-s390@vger.kernel.org
+S:	Supported
+
 S390 ZFCP DRIVER
 P:	Christof Schmitt
 M:	christof.schmitt@de.ibm.com

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

