Return-Path: <linux-kernel-owner+w=401wt.eu-S1757269AbYGFMsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269AbYGFMsQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 08:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbYGFMsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 08:48:04 -0400
Received: from zakalwe.fi ([80.83.5.154]:34995 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754104AbYGFMsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 08:48:04 -0400
Date: Sun, 6 Jul 2008 15:48:02 +0300
From: Heikki Orsila <heikki.orsila@iki.fi>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] kconfig: fix typos: "Suport" -> "Support"
Message-ID: <20080706124802.GA15853@zakalwe.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Heikki Orsila <heikki.orsila@iki.fi>
---
 drivers/misc/Kconfig |    2 +-
 init/Kconfig         |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 636af28..af4e76c 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -315,7 +315,7 @@ config THINKPAD_ACPI_VIDEO
 	  If you are not sure, say Y here.
 
 config THINKPAD_ACPI_HOTKEY_POLL
-	bool "Suport NVRAM polling for hot keys"
+	bool "Support NVRAM polling for hot keys"
 	depends on THINKPAD_ACPI
 	default y
 	---help---
diff --git a/init/Kconfig b/init/Kconfig
index 6199d11..9f7f92d 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -486,7 +486,7 @@ config PID_NS
 	default n
 	depends on NAMESPACES && EXPERIMENTAL
 	help
-	  Suport process id namespaces.  This allows having multiple
+	  Support process id namespaces.  This allows having multiple
 	  process with the same pid as long as they are in different
 	  pid namespaces.  This is a building block of containers.
 
-- 
1.5.5.1.1.ga5e5c
