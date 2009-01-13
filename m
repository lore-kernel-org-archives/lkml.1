Return-Path: <linux-kernel-owner+w=401wt.eu-S1758540AbZAMU2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540AbZAMU2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 15:28:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755600AbZAMU1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 15:27:45 -0500
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2528 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854AbZAMU1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 15:27:43 -0500
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 04/10] MAINTAINERS - Remove CS4280
Date: Tue, 13 Jan 2009 12:28:12 -0800
Message-Id: <1231878498-25171-5-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1231878498-25171-1-git-send-email-joe@perches.com>
References: <1231878498-25171-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unsupported Cirrus Logic CS4280 driver

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 87ce75b..4b6ec2a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1319,15 +1319,6 @@ S:	Supported
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

