Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbYKRROt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbYKRROt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 12:14:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbYKRRNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 12:13:37 -0500
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4477 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbYKRRNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 12:13:34 -0500
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@strlen.de>,
       Pavel Machek <pavel@suse.cz>
Subject: [PATCH 04/10] MAINTAINERS - Remove CS4280
Date: Tue, 18 Nov 2008 09:13:16 -0800
Message-Id: <1227028402-1548-5-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1227028402-1548-1-git-send-email-joe@perches.com>
References: <1227028402-1548-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unsupported Cirrus Logic CS4280 driver

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3acd7a6..c0d5efd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1307,15 +1307,6 @@ S:	Supported
 F:	sound/soc/codecs/cs4270*
 F:	sound/soc/fsl/mpc8610_hpcd.c
 
-CIRRUS LOGIC CS4280/CS461x SOUNDDRIVER
-P:	Cirrus Logic Corporation (kernel 2.2 driver)
-M:	Cirrus Logic Corporation, Thomas Woller <twoller@crystal.cirrus.com>
-P:	Nils Faerber (port to kernel 2.4)
-M:	Nils Faerber <nils@kernelconcepts.de>
-S:	Maintained
-F:	Documentation/input/cs461x.txt
-F:	sound/pci/cs46xx/
-
 CODA FILE SYSTEM
 P:	Jan Harkes
 M:	jaharkes@cs.cmu.edu
-- 
1.6.0.2

