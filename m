Return-Path: <linux-kernel-owner+w=401wt.eu-S968902AbXHMJY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968902AbXHMJY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967022AbXHMGcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:32:22 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1110 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967018AbXHMGcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:32:06 -0400
Date: Sun, 12 Aug 2007 23:31:52 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [314/2many] MAINTAINERS - MEMORY MANAGEMENT
Message-ID: <46bffad8.MhCbm7OlOxTaqjoh%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 2bb7a99..2c60699 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3024,6 +3024,8 @@ L:	linux-mm@kvack.org
 L:	linux-kernel@vger.kernel.org
 W:	http://www.linux-mm.org
 S:	Maintained
+F:	include/linux/mm.h
+F:	mm/
 
 MEMORY TECHNOLOGY DEVICES (MTD)
 P:	David Woodhouse
