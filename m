Return-Path: <linux-kernel-owner+w=401wt.eu-S968955AbXHMIVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968955AbXHMIVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966749AbXHMG2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:28:55 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4554 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966738AbXHMG2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:28:53 -0400
Date: Sun, 12 Aug 2007 23:28:40 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux@highpoint-tech.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [220/2many] MAINTAINERS - HIGHPOINT ROCKETRAID 3xxx RAID
 DRIVER
Message-ID: <46bffa18.tOnjTi8ceZ0LePby%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index ac6c822..d2c0bc7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2098,6 +2098,8 @@ P:	HighPoint Linux Team
 M:	linux@highpoint-tech.com
 W:	http://www.highpoint-tech.com
 S:	Supported
+F:	Documentation/scsi/hptiop.txt
+F:	drivers/scsi/hptiop.c
 
 HIPPI
 P:	Jes Sorensen
