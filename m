Return-Path: <linux-kernel-owner+w=401wt.eu-S1758908AbZBBVtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758908AbZBBVtn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 16:49:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757336AbZBBVte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 16:49:34 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:56187 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755501AbZBBVtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 16:49:33 -0500
Subject: [PATCH] regulator: email - update email address and regulator
 webpage.
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 02 Feb 2009 21:49:29 +0000
Message-Id: <1233611370.6976.80.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove deceased email address and update to new address. Also update
website details in MAINTAINERS with correct page.

Signed-off-by: Liam Girdwood <lrg@slimlogic.co.uk>
---
 MAINTAINERS                        |    2 +-
 include/linux/regulator/consumer.h |    2 +-
 include/linux/regulator/driver.h   |    2 +-
 include/linux/regulator/machine.h  |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 474ec0c..369e913 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4735,7 +4735,7 @@ M:	lrg@slimlogic.co.uk
 P:	Mark Brown
 M:	broonie@opensource.wolfsonmicro.com
 W:	http://opensource.wolfsonmicro.com/node/15
-W:	http://www.slimlogic.co.uk/?page_id=5
+W:	http://www.slimlogic.co.uk/?p=48
 T:	git kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git
 S:	Supported
 
diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index 533f4e2..df6c4bc 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2007, 2008 Wolfson Microelectronics PLC.
  *
- * Author: Liam Girdwood <lg@opensource.wolfsonmicro.com>
+ * Author: Liam Girdwood <lrg@slimlogic.co.uk>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index eb8773b..0cf37bc 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2007, 2008 Wolfson Microelectronics PLC.
  *
- * Author: Liam Girdwood <lg@opensource.wolfsonmicro.com>
+ * Author: Liam Girdwood <lrg@slimlogic.co.uk>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/include/linux/regulator/machine.h b/include/linux/regulator/machine.h
index 3794773..5aa00ee 100644
--- a/include/linux/regulator/machine.h
+++ b/include/linux/regulator/machine.h
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2007, 2008 Wolfson Microelectronics PLC.
  *
- * Author: Liam Girdwood <lg@opensource.wolfsonmicro.com>
+ * Author: Liam Girdwood <lrg@slimlogic.co.uk>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
-- 
1.5.6.3


