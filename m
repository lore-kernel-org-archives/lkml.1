Return-Path: <linux-kernel-owner+w=401wt.eu-S934515AbZIEB3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934515AbZIEB3y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 21:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933964AbZIEB3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 21:29:53 -0400
Received: from mail.michael-prokop.at ([88.198.6.110]:59218 "EHLO
	mail.michael-prokop.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933932AbZIEB3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 21:29:52 -0400
X-Greylist: delayed 1813 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Sep 2009 21:29:52 EDT
From: Michael Prokop <mika@grml.org>
To: linux-kernel@vger.kernel.org, Mike Rapoport <mike@compulab.co.il>
Cc: Michael Prokop <mika@grml.org>
Subject: [PATCH] drivers/regulator/Kconfig: fix typo (s/Usersapce/Userspace/) in REGULATOR_USERSPACE_CONSUMER description
Date: Sat,  5 Sep 2009 02:59:14 +0200
Message-Id: <1252112354-20006-1-git-send-email-mika@grml.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Michael Prokop <mika@grml.org>
---
 drivers/regulator/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index f431779..4d9fa22 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -52,7 +52,7 @@ config REGULATOR_USERSPACE_CONSUMER
 	default n
 	help
 	  There are some classes of devices that are controlled entirely
-	  from user space. Usersapce consumer driver provides ability to
+	  from user space. Userspace consumer driver provides ability to
 	  control power supplies for such devices.
 
           If unsure, say no.
-- 
1.6.3.3

