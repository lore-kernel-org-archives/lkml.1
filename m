Return-Path: <linux-kernel-owner+w=401wt.eu-S934298AbXLQTmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934298AbXLQTmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757613AbXLQTbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:31:50 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2981 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761061AbXLQTbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:31:42 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Len Brown <len.brown@intel.com>,
       lenb@kernel.org, linux-acpi@vger.kernel.org
Subject: [PATCH] drivers/acpi/: Spelling fixes
Date: Mon, 17 Dec 2007 11:30:25 -0800
Message-Id: <1197919875-5288-26-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918890.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/acpi/scan.c              |    2 +-
 drivers/acpi/utilities/utresrc.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 5b4d462..fad2eaa 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -830,7 +830,7 @@ static int acpi_bus_get_flags(struct acpi_device *device)
 	if (ACPI_SUCCESS(status))
 		device->flags.wake_capable = 1;
 
-	/* TBD: Peformance management */
+	/* TBD: Performance management */
 
 	return 0;
 }
diff --git a/drivers/acpi/utilities/utresrc.c b/drivers/acpi/utilities/utresrc.c
index cbbd331..b630ee1 100644
--- a/drivers/acpi/utilities/utresrc.c
+++ b/drivers/acpi/utilities/utresrc.c
@@ -1,6 +1,6 @@
 /*******************************************************************************
  *
- * Module Name: utresrc - Resource managment utilities
+ * Module Name: utresrc - Resource management utilities
  *
  ******************************************************************************/
 
-- 
1.5.3.7.949.g2221a6

