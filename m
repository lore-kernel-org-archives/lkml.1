Return-Path: <linux-kernel-owner+w=401wt.eu-S1761646AbXHMKJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761646AbXHMKJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967188AbXHMGe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:34:27 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1537 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967182AbXHMGeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:34:23 -0400
Date: Sun, 12 Aug 2007 23:34:00 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       kernel-discuss@handhelds.org, dwmw2@infradead.org, cbou@mail.ru,
       akpm@linux-foundation.org
Subject: [PATCH] [380/2many] MAINTAINERS - POWER SUPPLY CLASS/SUBSYSTEM
 and DRIVERS
Message-ID: <46bffb58.EyW+FLVPZpfX0qyO%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 58602ab..0d30368 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3649,6 +3649,8 @@ L:	linux-kernel@vger.kernel.org
 L:	kernel-discuss@handhelds.org
 T:	git git.infradead.org/battery-2.6.git
 S:	Maintained
+F:	include/linux/power_supply.h
+F:	drivers/power/power_supply*
 
 POWERPC 4xx EMAC DRIVER
 P:	Eugene Surovegin
