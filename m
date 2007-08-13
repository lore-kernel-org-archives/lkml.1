Return-Path: <linux-kernel-owner+w=401wt.eu-S941864AbXHMHb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941864AbXHMHb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965821AbXHMGZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:25:55 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4048 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966212AbXHMGZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:25:48 -0400
Date: Sun, 12 Aug 2007 23:25:32 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, mhw@wittsend.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [132/2many] MAINTAINERS - COMPUTONE INTELLIPORT MULTIPORT CARD
Message-ID: <46bff95c.B/AyYjDHD4l0m/DL%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 4898b55..594881d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1277,6 +1277,9 @@ P:	Michael H. Warfield
 M:	mhw@wittsend.com
 W:	http://www.wittsend.com/computone.html
 S:	Maintained
+F:	Documentation/computone.txt
+F:	drivers/char/ip2/
+F:	drivers/serial/8250_pci.c
 
 CONEXANT ACCESSRUNNER USB DRIVER
 P:	Simon Arlott
