Return-Path: <linux-kernel-owner+w=401wt.eu-S1754317AbXD2DXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317AbXD2DXq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 23:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754496AbXD2DXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 23:23:03 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:34270 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330AbXD2DWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 23:22:31 -0400
X-IronPort-AV: i="4.14,465,1170651600"; 
   d="scan'208"; a="36822433:sNHT19072074"
From: Bryan Wu <bryan.wu@analog.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 4/7] blackfin arch: need linux/tty.h header for console_init() prototype
Date: Sun, 29 Apr 2007 11:23:10 +0800
Message-Id: <11778169952502-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11778169933996-git-send-email-bryan.wu@analog.com>
References: <11778169933996-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/kernel/setup.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index 724fd7a..342bb8d 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -34,6 +34,7 @@
 #include <linux/cpu.h>
 #include <linux/module.h>
 #include <linux/console.h>
+#include <linux/tty.h>
 
 #include <linux/ext2_fs.h>
 #include <linux/cramfs_fs.h>
-- 
1.5.1.2
