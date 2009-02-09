Return-Path: <linux-kernel-owner+w=401wt.eu-S1755733AbZBIWsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733AbZBIWsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 17:48:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbZBIWsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 17:48:46 -0500
Received: from ns2.suse.de ([195.135.220.15]:57651 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196AbZBIWsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 17:48:45 -0500
From: Bernhard Walle <bernhard.walle@gmx.de>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Bernhard Walle <bernhard.walle@gmx.de>
Subject: [PATCH] Correct email address
Date: Mon,  9 Feb 2009 23:48:42 +0100
Message-Id: <1234219722-8196-1-git-send-email-bernhard.walle@gmx.de>
X-Mailer: git-send-email 1.6.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since I don't work for SUSE any more and the bwalle@suse.de address is invalid,
correct it in the copyright headers and documentation.


Signed-off-by: Bernhard Walle <bernhard.walle@gmx.de>
---
 Documentation/ABI/testing/sysfs-firmware-memmap |    2 +-
 drivers/firmware/memmap.c                       |    2 +-
 include/linux/firmware-map.h                    |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-firmware-memmap b/Documentation/ABI/testing/sysfs-firmware-memmap
index 0d99ee6..eca0d65 100644
--- a/Documentation/ABI/testing/sysfs-firmware-memmap
+++ b/Documentation/ABI/testing/sysfs-firmware-memmap
@@ -1,6 +1,6 @@
 What:		/sys/firmware/memmap/
 Date:		June 2008
-Contact:	Bernhard Walle <bwalle@suse.de>
+Contact:	Bernhard Walle <bernhard.walle@gmx.de>
 Description:
 		On all platforms, the firmware provides a memory map which the
 		kernel reads. The resources from that memory map are registered
diff --git a/drivers/firmware/memmap.c b/drivers/firmware/memmap.c
index 261b9aa..05aa2d4 100644
--- a/drivers/firmware/memmap.c
+++ b/drivers/firmware/memmap.c
@@ -1,7 +1,7 @@
 /*
  * linux/drivers/firmware/memmap.c
  *  Copyright (C) 2008 SUSE LINUX Products GmbH
- *  by Bernhard Walle <bwalle@suse.de>
+ *  by Bernhard Walle <bernhard.walle@gmx.de>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License v2.0 as published by
diff --git a/include/linux/firmware-map.h b/include/linux/firmware-map.h
index 6e199c8..cca686b 100644
--- a/include/linux/firmware-map.h
+++ b/include/linux/firmware-map.h
@@ -1,7 +1,7 @@
 /*
  * include/linux/firmware-map.h:
  *  Copyright (C) 2008 SUSE LINUX Products GmbH
- *  by Bernhard Walle <bwalle@suse.de>
+ *  by Bernhard Walle <bernhard.walle@gmx.de>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License v2.0 as published by
-- 
1.6.1.3

