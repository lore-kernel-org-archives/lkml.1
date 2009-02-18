Return-Path: <linux-kernel-owner+w=401wt.eu-S1757110AbZBRTWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110AbZBRTWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 14:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755866AbZBRTVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 14:21:35 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:19199 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665AbZBRTVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 14:21:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=nWXgI8TdhcwvDrUa0/zaKGs1Pd42okUtYBAMPhtTBMLkWtxfvtrvluJI4PG3yqEfho
         BvC2N7TuvAFhI7cgGpuyN/o16d0Z1O5Vmd0gPHaymvuTjcu2FCcyR/P6Jr4hvOx7YExq
         gyzHjXJ4BES0bDGlXYV2CWJgpAjXGf+tUp8ic=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] it821x: remove dead URL
Date: Wed, 18 Feb 2009 20:18:03 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-next-20090218; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902182018.04495.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] it821x: remove dead URL

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/it821x.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: b/drivers/ide/it821x.c
===================================================================
--- a/drivers/ide/it821x.c
+++ b/drivers/ide/it821x.c
@@ -5,9 +5,8 @@
  *  May be copied or modified under the terms of the GNU General Public License
  *  Based in part on the ITE vendor provided SCSI driver.
  *
- *  Documentation available from
- * 	http://www.ite.com.tw/pc/IT8212F_V04.pdf
- *  Some other documents are NDA.
+ *  Documentation:
+ *	Datasheet is freely available, some other documents under NDA.
  *
  *  The ITE8212 isn't exactly a standard IDE controller. It has two
  *  modes. In pass through mode then it is an IDE controller. In its smart
