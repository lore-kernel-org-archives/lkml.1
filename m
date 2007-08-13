Return-Path: <linux-kernel-owner+w=401wt.eu-S972136AbXHMJyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S972136AbXHMJyr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967145AbXHMGdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:33:51 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1426 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967125AbXHMGds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:33:48 -0400
Date: Sun, 12 Aug 2007 23:33:33 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, jim.cromie@gmail.com,
       akpm@linux-foundation.org
Subject: [PATCH] [366/2many] MAINTAINERS - PC87360 HARDWARE MONITORING
 DRIVER
Message-ID: <46bffb3d./BjKtJyDtveL1fJQ%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 44768ce..2eb1a7c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3528,6 +3528,8 @@ P:	Jim Cromie
 M:	jim.cromie@gmail.com
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	Documentation/hwmon/pc87360
+F:	drivers/hwmon/pc87360.c
 
 PC8736x GPIO DRIVER
 P:	Jim Cromie
