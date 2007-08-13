Return-Path: <linux-kernel-owner+w=401wt.eu-S968555AbXHMH7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968555AbXHMH7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966452AbXHMG1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:27:33 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4360 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966518AbXHMG1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:27:31 -0400
Date: Sun, 12 Aug 2007 23:27:18 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, miku@iki.fi, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [185/2many] MAINTAINERS - ETHERTEAM 16I DRIVER
Message-ID: <46bff9c6.p+G7sCiRAoHa6COX%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 27eb5be..85ab9fe 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1787,6 +1787,7 @@ ETHERTEAM 16I DRIVER
 P:	Mika Kuoppala
 M:	miku@iki.fi
 S:	Maintained
+F:	drivers/net/eth16i.c
 
 EXT2 FILE SYSTEM
 L:	linux-ext4@vger.kernel.org
