Return-Path: <linux-kernel-owner+w=401wt.eu-S965686AbXHMHzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965686AbXHMHzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966482AbXHMG1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:27:23 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4321 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966475AbXHMG1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:27:20 -0400
Date: Sun, 12 Aug 2007 23:27:07 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, saw@saw.sw.com.sg,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [179/2many] MAINTAINERS - EEPRO100 NETWORK DRIVER
Message-ID: <46bff9bb.oi8C4U0iANrVFIrM%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 84f6f6b..208bfea 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1737,6 +1737,7 @@ EEPRO100 NETWORK DRIVER
 P:	Andrey V. Savochkin
 M:	saw@saw.sw.com.sg
 S:	Maintained
+F:	drivers/net/eepro100.c
 
 EFS FILESYSTEM
 W:	http://aeschi.ch.eu.org/efs/
