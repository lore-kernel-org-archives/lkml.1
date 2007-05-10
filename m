Return-Path: <linux-kernel-owner+w=401wt.eu-S1759000AbXEJTcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759000AbXEJTcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 15:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbXEJTb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 15:31:59 -0400
Received: from mail0.lsil.com ([147.145.40.20]:54072 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757481AbXEJTb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 15:31:58 -0400
Subject: [PATCH]: Update Maintainer email-id for MegaRAID SCSI drivers
From: Sumant Patro <sumant.patro@lsi.com>
To: akpm@osdl.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       James.Bottomley@SteelEye.com
Cc: Neela.Kolli@lsi.com, Bo.Yang@lsi.com, sumant.patro@lsi.com
Content-Type: text/plain
Date: Thu, 10 May 2007 07:22:35 -0700
Message-Id: <1178806955.4681.13.camel@dumbo>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-22) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Update Maintainer email-id for MegaRAID SCSI drivers.

Signed-off-by: Sumant Patro <sumant.patro@lsi.com>
---

diff -uprN orig/MAINTAINERS new/MAINTAINERS
--- orig/MAINTAINERS	2007-05-10 07:13:22.000000000 -0700
+++ new/MAINTAINERS	2007-05-10 07:12:58.000000000 -0700
@@ -2268,7 +2268,7 @@ S:	Maintained
 
 MEGARAID SCSI DRIVERS
 P:	Neela Syam Kolli
-M:	Neela.Kolli@engenio.com
+M:	megaraidlinux@lsi.com
 S:	linux-scsi@vger.kernel.org
 W:	http://megaraid.lsilogic.com
 S:	Maintained


