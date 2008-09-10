Return-Path: <linux-kernel-owner+w=401wt.eu-S1754448AbYIJTwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbYIJTwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 15:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbYIJTvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 15:51:50 -0400
Received: from atlas.informatik.uni-freiburg.de ([132.230.150.3]:40387 "EHLO
	atlas.informatik.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752248AbYIJTvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 15:51:48 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<ukleinek@informatik.uni-freiburg.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: remove real names from M fields
Date: Wed, 10 Sep 2008 21:51:37 +0200
Message-Id: <1221076300-7018-3-git-send-email-ukleinek@informatik.uni-freiburg.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1221076300-7018-2-git-send-email-ukleinek@informatik.uni-freiburg.de>
References: <20080910193210.GA26173@informatik.uni-freiburg.de>
 <1221076300-7018-1-git-send-email-ukleinek@informatik.uni-freiburg.de>
 <1221076300-7018-2-git-send-email-ukleinek@informatik.uni-freiburg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: Universitaet Freiburg, Institut f. Informatik
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of the next commit merges P and M fields.  So the real name is only
needed once.

Signed-off-by: Uwe Kleine-König <ukleinek@informatik.uni-freiburg.de>
---
 MAINTAINERS |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6b2ea6e..19fa2d5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -335,7 +335,7 @@ S:	Maintained
 
 AHA152X SCSI DRIVER
 P:	Juergen E. Fischer
-M:	Juergen Fischer <fischer@norbit.de>
+M:	fischer@norbit.de
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 
@@ -2064,14 +2064,14 @@ S:	Maintained
 
 IDE/ATAPI FLOPPY DRIVERS
 P:	Paul Bristow
-M:	Paul Bristow <paul@paulbristow.net>
+M:	paul@paulbristow.net
 W:	http://paulbristow.net/linux/idefloppy.html
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
 IDE/ATAPI TAPE DRIVERS
 P:	Gadi Oxman
-M:	Gadi Oxman <gadio@netvision.net.il>
+M:	gadio@netvision.net.il
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
-- 
1.5.6.5

