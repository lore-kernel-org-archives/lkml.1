Return-Path: <linux-kernel-owner+w=401wt.eu-S970006AbXHMJua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970006AbXHMJua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967134AbXHMGdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:33:41 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1364 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967113AbXHMGda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:33:30 -0400
Date: Sun, 12 Aug 2007 23:33:11 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       laforge@gnumonks.org, akpm@linux-foundation.org
Subject: [PATCH] [355/2many] MAINTAINERS - OMNIKEY CARDMAN 4040 DRIVER
Message-ID: <46bffb27.JDlYDY5CuaHFphbv%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 883d696..abac381 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3418,6 +3418,7 @@ OMNIKEY CARDMAN 4040 DRIVER
 P:	Harald Welte
 M:	laforge@gnumonks.org
 S:	Maintained
+F:	drivers/char/pcmcia/cm4040_cs.*
 
 OMNIVISION OV7670 SENSOR DRIVER
 P:   	Jonathan Corbet
