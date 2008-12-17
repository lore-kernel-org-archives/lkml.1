Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752762AbYLQTaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbYLQTaQ (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 14:30:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbYLQT3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 14:29:16 -0500
Received: from kroah.org ([198.145.64.141]:54234 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751386AbYLQT3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 14:29:14 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
        stable <stable@kernel.org>
Subject: [PATCH 2/4] xilinx_hwicap: remove improper wording in license statement
Date: Wed, 17 Dec 2008 11:28:21 -0800
Message-Id: <1229542103-24678-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20081217192737.GA24641@kroah.com>
References: <20081217192737.GA24641@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GPLv2 doesn't allow additional restrictions to be imposed on any
code, so this wording needs to be removed from these files.

Signed-off-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/xilinx_hwicap/buffer_icap.c   |    3 ---
 drivers/char/xilinx_hwicap/buffer_icap.h   |    3 ---
 drivers/char/xilinx_hwicap/fifo_icap.c     |    3 ---
 drivers/char/xilinx_hwicap/fifo_icap.h     |    3 ---
 drivers/char/xilinx_hwicap/xilinx_hwicap.c |    3 ---
 drivers/char/xilinx_hwicap/xilinx_hwicap.h |    3 ---
 6 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/drivers/char/xilinx_hwicap/buffer_icap.c b/drivers/char/xilinx_hwicap/buffer_icap.c
index aa7f796..05d8977 100644
--- a/drivers/char/xilinx_hwicap/buffer_icap.c
+++ b/drivers/char/xilinx_hwicap/buffer_icap.c
@@ -21,9 +21,6 @@
  *     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
  *     FOR A PARTICULAR PURPOSE.
  *
- *     Xilinx products are not intended for use in life support appliances,
- *     devices, or systems. Use in such applications is expressly prohibited.
- *
  *     (c) Copyright 2003-2008 Xilinx Inc.
  *     All rights reserved.
  *
diff --git a/drivers/char/xilinx_hwicap/buffer_icap.h b/drivers/char/xilinx_hwicap/buffer_icap.h
index 8b0252b..d4f419e 100644
--- a/drivers/char/xilinx_hwicap/buffer_icap.h
+++ b/drivers/char/xilinx_hwicap/buffer_icap.h
@@ -21,9 +21,6 @@
  *     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
  *     FOR A PARTICULAR PURPOSE.
  *
- *     Xilinx products are not intended for use in life support appliances,
- *     devices, or systems. Use in such applications is expressly prohibited.
- *
  *     (c) Copyright 2003-2008 Xilinx Inc.
  *     All rights reserved.
  *
diff --git a/drivers/char/xilinx_hwicap/fifo_icap.c b/drivers/char/xilinx_hwicap/fifo_icap.c
index 776b505..02225eb 100644
--- a/drivers/char/xilinx_hwicap/fifo_icap.c
+++ b/drivers/char/xilinx_hwicap/fifo_icap.c
@@ -21,9 +21,6 @@
  *     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
  *     FOR A PARTICULAR PURPOSE.
  *
- *     Xilinx products are not intended for use in life support appliances,
- *     devices, or systems. Use in such applications is expressly prohibited.
- *
  *     (c) Copyright 2007-2008 Xilinx Inc.
  *     All rights reserved.
  *
diff --git a/drivers/char/xilinx_hwicap/fifo_icap.h b/drivers/char/xilinx_hwicap/fifo_icap.h
index 62bda45..4c9dd9a 100644
--- a/drivers/char/xilinx_hwicap/fifo_icap.h
+++ b/drivers/char/xilinx_hwicap/fifo_icap.h
@@ -21,9 +21,6 @@
  *     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
  *     FOR A PARTICULAR PURPOSE.
  *
- *     Xilinx products are not intended for use in life support appliances,
- *     devices, or systems. Use in such applications is expressly prohibited.
- *
  *     (c) Copyright 2007-2008 Xilinx Inc.
  *     All rights reserved.
  *
diff --git a/drivers/char/xilinx_hwicap/xilinx_hwicap.c b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
index d161319..f40ab69 100644
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.c
+++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
@@ -21,9 +21,6 @@
  *     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
  *     FOR A PARTICULAR PURPOSE.
  *
- *     Xilinx products are not intended for use in life support appliances,
- *     devices, or systems. Use in such applications is expressly prohibited.
- *
  *     (c) Copyright 2002 Xilinx Inc., Systems Engineering Group
  *     (c) Copyright 2004 Xilinx Inc., Systems Engineering Group
  *     (c) Copyright 2007-2008 Xilinx Inc.
diff --git a/drivers/char/xilinx_hwicap/xilinx_hwicap.h b/drivers/char/xilinx_hwicap/xilinx_hwicap.h
index 24d0d9b..8cca119 100644
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.h
+++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.h
@@ -21,9 +21,6 @@
  *     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
  *     FOR A PARTICULAR PURPOSE.
  *
- *     Xilinx products are not intended for use in life support appliances,
- *     devices, or systems. Use in such applications is expressly prohibited.
- *
  *     (c) Copyright 2003-2007 Xilinx Inc.
  *     All rights reserved.
  *
-- 
1.6.0.4

