Return-Path: <linux-kernel-owner+w=401wt.eu-S942330AbXHML5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942330AbXHML5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967483AbXHMGju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:39:50 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2424 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966353AbXHMGjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:39:49 -0400
Date: Sun, 12 Aug 2007 23:39:36 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, r.marek@assembler.cz,
       lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [538/2many] MAINTAINERS - W83793 HARDWARE MONITORING
 DRIVER
Message-ID: <46bffca8.KnIBclsJw5/Ay0TK%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 4e7906f..dcbcd74 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5086,6 +5086,8 @@ P:	Rudolf Marek
 M:	r.marek@assembler.cz
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	Documentation/hwmon/w83793
+F:	drivers/hwmon/w83793.c
 
 W83L51xD SD/MMC CARD INTERFACE DRIVER
 P:	Pierre Ossman
