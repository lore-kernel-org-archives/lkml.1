Return-Path: <linux-kernel-owner+w=401wt.eu-S937831AbXHML4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937831AbXHML4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966113AbXHMGjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:39:49 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2423 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967477AbXHMGjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:39:48 -0400
Date: Sun, 12 Aug 2007 23:39:34 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, bezaur@gmail.com,
       akpm@linux-foundation.org
Subject: [PATCH] [537/2many] MAINTAINERS - W83791D HARDWARE MONITORING
 DRIVER
Message-ID: <46bffca6.C3ZDFVo2GLTkFeKl%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 3871621..4e7906f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5070,12 +5070,16 @@ W1 DALLAS'S 1-WIRE BUS
 P:	Evgeniy Polyakov
 M:	johnpol@2ka.mipt.ru
 S:	Maintained
+F:	Documentation/w1/
+F:	drivers/w1/
 
 W83791D HARDWARE MONITORING DRIVER
 P:	Charles Spirakis
 M:	bezaur@gmail.com
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
+F:	Documentation/hwmon/w83791d
+F:	drivers/hwmon/w83791d.c
 
 W83793 HARDWARE MONITORING DRIVER
 P:	Rudolf Marek
