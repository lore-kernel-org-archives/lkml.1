Return-Path: <linux-kernel-owner+w=401wt.eu-S1756195AbYILKA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195AbYILKA5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 06:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbYILKAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 06:00:23 -0400
Received: from atlas.informatik.uni-freiburg.de ([132.230.150.3]:52224 "EHLO
	atlas.informatik.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752926AbYILKAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 06:00:22 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<ukleinek@informatik.uni-freiburg.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Cc: Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH] MAINTAINERS: remove real names from M fields
Date: Fri, 12 Sep 2008 12:00:15 +0200
Message-Id: <1221213616-23299-3-git-send-email-ukleinek@informatik.uni-freiburg.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1221213616-23299-2-git-send-email-ukleinek@informatik.uni-freiburg.de>
References: <20080912095851.GA3174@informatik.uni-freiburg.de>
 <1221213616-23299-1-git-send-email-ukleinek@informatik.uni-freiburg.de>
 <1221213616-23299-2-git-send-email-ukleinek@informatik.uni-freiburg.de>
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
 MAINTAINERS |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index cd46667..a4932fd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -335,7 +335,7 @@ S:	Maintained
 
 AHA152X SCSI DRIVER
 P:	Juergen E. Fischer
-M:	Juergen Fischer <fischer@norbit.de>
+M:	fischer@norbit.de
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 
@@ -1114,7 +1114,7 @@ S:	Supported
 
 CIRRUS LOGIC CS4280/CS461x SOUNDDRIVER
 P:	Nils Faerber (port to kernel 2.4)
-M:	Nils Faerber <nils@kernelconcepts.de>
+M:	nils@kernelconcepts.de
 S:	Maintained
 
 CODA FILE SYSTEM
@@ -2062,14 +2062,14 @@ S:	Maintained
 
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

