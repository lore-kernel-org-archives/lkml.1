Return-Path: <linux-kernel-owner+w=401wt.eu-S1760849AbZJINyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760849AbZJINyF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 09:54:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760798AbZJINyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 09:54:04 -0400
Received: from server1.wserver.cz ([82.113.45.157]:37639 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbZJINyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 09:54:03 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: len.brown@intel.com
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] ACPI: Kconfig, fix proc aggregator text
Date: Fri,  9 Oct 2009 15:53:24 +0200
Message-Id: <1255096404-23017-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix two typos in the Kconfig text about ACPI_PROCESSOR_AGGREGATOR.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/acpi/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 0ed42d8..93d2c79 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -218,10 +218,10 @@ config ACPI_PROCESSOR_AGGREGATOR
 	depends on X86
 	help
 	  ACPI 4.0 defines processor Aggregator, which enables OS to perform
-	  specfic processor configuration and control that applies to all
+	  specific processor configuration and control that applies to all
 	  processors in the platform. Currently only logical processor idling
 	  is defined, which is to reduce power consumption. This driver
-	  support the new device.
+	  supports the new device.
 
 config ACPI_THERMAL
 	tristate "Thermal Zone"
-- 
1.6.4.2

