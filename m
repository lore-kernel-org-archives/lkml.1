Return-Path: <linux-kernel-owner+w=401wt.eu-S1761208AbYJKHBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761208AbYJKHBp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 03:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757955AbYJKGlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:41:00 -0400
Received: from vms172071pub.verizon.net ([206.46.172.71]:52133 "EHLO
	vms172071pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbYJKGgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:36:54 -0400
Date: Sat, 11 Oct 2008 02:35:38 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 18/85] ACPICA: Update version to 20080701
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       Andi Kleen <ak@linux.intel.com>, Len Brown <len.brown@intel.com>
Message-id: <7c7d9564293b2acc1d5c609ad8c421fbae546248.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

Update version to 20080701.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 include/acpi/acconfig.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/acpi/acconfig.h b/include/acpi/acconfig.h
index 4eb75a8..328caee 100644
--- a/include/acpi/acconfig.h
+++ b/include/acpi/acconfig.h
@@ -63,7 +63,7 @@
 
 /* Current ACPICA subsystem version in YYYYMMDD format */
 
-#define ACPI_CA_VERSION 		0x20080609
+#define ACPI_CA_VERSION 		0x20080701
 
 /*
  * OS name, used for the _OS object.  The _OS object is essentially obsolete,
-- 
1.5.5.1

