Return-Path: <linux-kernel-owner+w=401wt.eu-S1763966AbXLQTkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763966AbXLQTkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757978AbXLQTbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:31:51 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2986 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761074AbXLQTbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:31:43 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] include/acpi/: Spelling fixes
Date: Mon, 17 Dec 2007 11:30:26 -0800
Message-Id: <1197919875-5288-27-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918890.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/acpi/acpixf.h    |    2 +-
 include/acpi/processor.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index 9512f04..18a6377 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -85,7 +85,7 @@ acpi_install_initialization_handler(acpi_init_handler handler, u32 function);
 #endif
 
 /*
- * ACPI Memory managment
+ * ACPI Memory management
  */
 void *acpi_allocate(u32 size);
 
diff --git a/include/acpi/processor.h b/include/acpi/processor.h
index 76411b1..6e253b5 100644
--- a/include/acpi/processor.h
+++ b/include/acpi/processor.h
@@ -182,7 +182,7 @@ struct acpi_processor_throttling {
 /* Limit Interface */
 
 struct acpi_processor_lx {
-	int px;			/* performace state */
+	int px;			/* performance state */
 	int tx;			/* throttle level */
 };
 
-- 
1.5.3.7.949.g2221a6

