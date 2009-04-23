Return-Path: <linux-kernel-owner+w=401wt.eu-S1757506AbZDWUpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbZDWUpM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 16:45:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756214AbZDWUoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 16:44:32 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:31787 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755998AbZDWUo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 16:44:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=j1z7a8A3SQbhu0G78A05zTgvLFsOTpvY55msLUt5mCVulm6FMmJQYtyrZl2OOZD7Ot
         mnAE41q0G7w2sr5AuyoiKDV9zrDVyvNjr4lo/IRQkvyfIE/hHgO+YLfllxauSljTCkkB
         vsyzIVu7WiCfH33PnEAUCVQBSlvRCaJAwhhzg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: update IDE entry
Date: Thu, 23 Apr 2009 22:48:31 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-next-20090403; KDE/4.2.2; i686; ; )
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904232248.31735.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


By a popular demand quilt tree was replaced by a git one.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/MAINTAINERS
===================================================================
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2743,7 +2743,7 @@ IDE SUBSYSTEM
 P:	Bartlomiej Zolnierkiewicz
 M:	bzolnier@gmail.com
 L:	linux-ide@vger.kernel.org
-T:	quilt kernel.org/pub/linux/kernel/people/bart/pata-2.6/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/bart/ide-2.6.git
 S:	Maintained
 F:	Documentation/ide/
 F:	drivers/ide/
