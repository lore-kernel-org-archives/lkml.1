Return-Path: <linux-kernel-owner+w=401wt.eu-S937214AbXHMKVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937214AbXHMKVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967113AbXHMGfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:35:09 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1648 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965671AbXHMGfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:35:04 -0400
Date: Sun, 12 Aug 2007 23:34:50 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, p_gortmaker@yahoo.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [405/2many] MAINTAINERS - REAL TIME CLOCK DRIVER
Message-ID: <46bffb8a.siOHKR7nBc1KZXn5%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 0e0e351..de22969 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3861,6 +3861,9 @@ P:	Paul Gortmaker
 M:	p_gortmaker@yahoo.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	Documentation/rtc.txt
+F:	drivers/rtc/
+F:	include/linux/rtc.h
 
 REAL TIME CLOCK (RTC) SUBSYSTEM
 P:	Alessandro Zummo
