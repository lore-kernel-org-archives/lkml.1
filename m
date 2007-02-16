Return-Path: <linux-kernel-owner+w=401wt.eu-S1946304AbXBPXiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946304AbXBPXiz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 18:38:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946301AbXBPXiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 18:38:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:51835 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946303AbXBPXiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 18:38:54 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 01/10] Driver.h copyright update
Date: Fri, 16 Feb 2007 15:37:27 -0800
Message-Id: <11716690562249-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.0
In-Reply-To: <20070216233553.GC14708@kroah.com>
References: <20070216233553.GC14708@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It was pointed out that I had not updated my copyright on driver.h

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/device.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index 26e4692..d5b1b7b 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -2,6 +2,7 @@
  * device.h - generic, centralized driver model
  *
  * Copyright (c) 2001-2003 Patrick Mochel <mochel@osdl.org>
+ * Copyright (c) 2004-2007 Greg Kroah-Hartman <gregkh@suse.de>
  *
  * This file is released under the GPLv2
  *
-- 
1.5.0

