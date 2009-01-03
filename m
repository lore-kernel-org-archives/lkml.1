Return-Path: <linux-kernel-owner+w=401wt.eu-S1759827AbZACHyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759827AbZACHyU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 02:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbZACHyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 02:54:12 -0500
Received: from vps1.tull.net ([66.180.172.116]:49110 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750759AbZACHyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 02:54:11 -0500
From: Nick Andrew <nick@nick-andrew.net>
Subject: [TRIVIAL PATCH 04/11] Fix misspelling of "firmware" in	acpi_memhotplug.c
To: Trivial Kernel Patches <trivial@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 03 Jan 2009 18:53:39 +1100
Message-ID: <20090103075329.27466.49700.stgit@marcab.local>
In-Reply-To: <20090103074923.27466.7287.stgit@marcab.local>
References: <20090103074923.27466.7287.stgit@marcab.local>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix misspelling of "firmware" in acpi_memhotplug.c

It's spelled "firmware".

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 drivers/acpi/acpi_memhotplug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index 63a17b5..7a0f4aa 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -20,7 +20,7 @@
  *
  *
  * ACPI based HotPlug driver that supports Memory Hotplug
- * This driver fields notifications from firmare for memory add
+ * This driver fields notifications from firmware for memory add
  * and remove operations and alerts the VM of the affected memory
  * ranges.
  */

