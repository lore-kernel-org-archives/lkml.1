Return-Path: <linux-kernel-owner+w=401wt.eu-S972503AbXHMNJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S972503AbXHMNJM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:09:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757770AbXHMI3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 04:29:38 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2725 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S969488AbXHMI3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 04:29:36 -0400
Date: Sun, 12 Aug 2007 23:33:35 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jim.cromie@gmail.com, akpm@linux-foundation.org
Subject: [PATCH] [367/2many] MAINTAINERS - PC8736x GPIO DRIVER
Message-ID: <46bffb3f.ITW25GI/Hpmx+7nk%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 2eb1a7c..c3bd8f8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3535,6 +3535,7 @@ PC8736x GPIO DRIVER
 P:	Jim Cromie
 M:	jim.cromie@gmail.com
 S:	Maintained
+F:	drivers/char/pc8736x_gpio.c
 
 PCI ERROR RECOVERY
 P:	Linas Vepstas
