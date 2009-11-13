Return-Path: <linux-kernel-owner+w=401wt.eu-S1756299AbZKMRmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299AbZKMRmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 12:42:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755244AbZKMRma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 12:42:30 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:43830 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932129AbZKMRlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 12:41:17 -0500
Date: Fri, 13 Nov 2009 12:41:19 -0500
From: Andres Salomon <dilinger@collabora.co.uk>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Jordan Crouse <jordan@cosmicpenguin.net>,
       linux-geode@lists.infradead.org,
       linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH] lxfb: add copyright/license info
Message-ID: <20091113124119.34ec8677@mycelium.queued.net>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The GRUB folks requested copyright/license info for lxfb.h, so here it is.

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
---
 drivers/video/geode/lxfb.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/video/geode/lxfb.h b/drivers/video/geode/lxfb.h
index 6a51448..67b26aa 100644
--- a/drivers/video/geode/lxfb.h
+++ b/drivers/video/geode/lxfb.h
@@ -1,3 +1,13 @@
+/* Geode LX framebuffer driver
+ *
+ * Copyright (C) 2006-2007, Advanced Micro Devices,Inc.
+ * Copyright (c) 2008  Andres Salomon <dilinger@debian.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ */
 #ifndef _LXFB_H_
 #define _LXFB_H_
 
-- 
1.5.6.5

