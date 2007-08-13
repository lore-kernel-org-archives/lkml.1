Return-Path: <linux-kernel-owner+w=401wt.eu-S970598AbXHMIyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970598AbXHMIyd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966837AbXHMGay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:30:54 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4848 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966321AbXHMGar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:30:47 -0400
Date: Sun, 12 Aug 2007 23:30:33 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, r.marek@assembler.cz,
       lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [273/2many] MAINTAINERS - K8TEMP HARDWARE MONITORING
 DRIVER
Message-ID: <46bffa89.j/g6mQ6Nh5XoqFGH%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index f0d1bce..3a9c079 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2614,6 +2614,8 @@ P:	Rudolf Marek
 M:	r.marek@assembler.cz
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	Documentation/hwmon/k8temp
+F:	drivers/hwmon/k8temp.c
 
 KCONFIG
 P:	Roman Zippel
