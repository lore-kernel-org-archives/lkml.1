Return-Path: <linux-kernel-owner+w=401wt.eu-S932608AbZACIA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608AbZACIA0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 03:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbZACIAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 03:00:11 -0500
Received: from vps1.tull.net ([66.180.172.116]:36664 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750767AbZACIAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 03:00:10 -0500
From: Nick Andrew <nick@nick-andrew.net>
Subject: [TRIVIAL PATCH 10/11] Fix misspelling of "firmware" in powerpc	Makefile
To: Trivial Kernel Patches <trivial@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 03 Jan 2009 18:59:37 +1100
Message-ID: <20090103075927.27466.41596.stgit@marcab.local>
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

Fix misspelling of "firmware" in powerpc Makefile

It's spelled "firmware".

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 arch/powerpc/boot/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/arch/powerpc/boot/Makefile b/arch/powerpc/boot/Makefile
index 3d3daa6..42b5a2d 100644
--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -207,7 +207,7 @@ image-$(CONFIG_DEFAULT_UIMAGE)		+= uImage
 #
 # Theses are default targets to build images which embed device tree blobs.
 # They are only required on boards which do not have FDT support in firmware.
-# Boards with newish u-boot firmare can use the uImage target above
+# Boards with newish u-boot firmware can use the uImage target above
 #
 
 # Board ports in arch/powerpc/platform/40x/Kconfig

