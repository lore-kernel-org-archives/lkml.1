Return-Path: <linux-kernel-owner+w=401wt.eu-S971046AbXHMJay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971046AbXHMJay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933248AbXHMGcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:32:35 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1195 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967034AbXHMGcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:32:33 -0400
Date: Sun, 12 Aug 2007 23:31:48 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, hjk@linutronix.de,
       akpm@linux-foundation.org
Subject: [PATCH] [312/2many] MAINTAINERS - MAX6650 HARDWARE MONITOR AND
 FAN CONTROLLER DRIVER
Message-ID: <46bffad4.XniGtsVMOQCJEtM1%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index f200501..ab3a4ae 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3006,6 +3006,8 @@ P:	Hans J. Koch
 M:	hjk@linutronix.de
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	Documentation/hwmon/max6650
+F:	drivers/hwmon/max6650.c
 
 MEGARAID SCSI DRIVERS
 P:	Neela Syam Kolli
