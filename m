Return-Path: <linux-kernel-owner+w=401wt.eu-S1754097AbXLRKQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbXLRKQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 05:16:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbXLRKQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 05:16:17 -0500
Received: from mtagate2.de.ibm.com ([195.212.29.151]:60406 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbXLRKQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 05:16:15 -0500
From: Swen Schillig <swen@vnet.ibm.com>
To: linux-scsi@vger.kernel.org
Subject: [PATCH] MAINTAINERS: zfcp
Date: Tue, 18 Dec 2007 11:16:14 +0100
User-Agent: KMail/1.9.5
Organization: IBM
Cc: linux-kernel@vger.kernel.org,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christof Schmitt <christof.schmitt@de.ibm.com>,
       Martin Peschke <mp3@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712181116.14381.swen@vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James

we are planning a major rewrite of the zfcp driver, 
meaning that a lot of patches will hit the mailing-list in the near future.

Since I can't support this additional work-load along with my other 
responsibilities we are shifting the maintainership to
Christof Schmitt as the maintainer and
Martin Peschke as the co-maintainer.

Please support the two in providing us a new and more stable
zfcp environment.

Thanks
Swen

---
 MAINTAINERS |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: scsi-misc/MAINTAINERS
===================================================================
--- scsi-misc.orig/MAINTAINERS
+++ scsi-misc/MAINTAINERS
@@ -3246,8 +3246,10 @@ W:	http://www.ibm.com/developerworks/lin
 S:	Supported
 
 S390 ZFCP DRIVER
-P:	Swen Schillig
-M:	swen@vnet.ibm.com
+P:	Christof Schmitt
+M:	christof.schmitt@de.ibm.com
+P:	Martin Peschke
+M:	mp3@de.ibm.com
 M:	linux390@de.ibm.com
 L:	linux-s390@vger.kernel.org
 W:	http://www.ibm.com/developerworks/linux/linux390/
