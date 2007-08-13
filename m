Return-Path: <linux-kernel-owner+w=401wt.eu-S942825AbXHMII2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942825AbXHMII2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966610AbXHMG2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:28:13 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4430 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966609AbXHMG2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:28:09 -0400
Date: Sun, 12 Aug 2007 23:27:55 -0700
From: joe@perches.com
To: viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [197/2many] MAINTAINERS - FILESYSTEMS (VFS and
 infrastructure)
Message-ID: <46bff9eb.6yO4AQWMbIwJfPZS%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index fbdd316..9aa822a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1892,6 +1892,7 @@ FILESYSTEMS (VFS and infrastructure)
 P:	Alexander Viro
 M:	viro@zeniv.linux.org.uk
 S:	Maintained
+F:	fs/*
 
 FIREWIRE SUBSYSTEM
 P:	Kristian Hoegsberg, Stefan Richter
