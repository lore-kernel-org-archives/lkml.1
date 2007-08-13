Return-Path: <linux-kernel-owner+w=401wt.eu-S968020AbXHMHsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968020AbXHMHsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966409AbXHMG0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:26:50 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4221 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966401AbXHMG0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:26:48 -0400
Date: Sun, 12 Aug 2007 23:26:34 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       gregkh@suse.de, akpm@linux-foundation.org
Subject: [PATCH] [162/2many] MAINTAINERS - DRIVER CORE, KOBJECTS, AND
 SYSFS
Message-ID: <46bff99a.g25EeFbh3piTY1CA%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 0939e34..5a96fac 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1581,6 +1581,11 @@ M:	gregkh@suse.de
 L:	linux-kernel@vger.kernel.org
 T:	quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
 S:	Supported
+F:	Documentation/kobject.txt
+F:	drivers/base/core.c
+F:	fs/sysfs/
+F:	include/linux/kobj*
+F:	lib/kobj*
 
 DRM DRIVERS
 P:	David Airlie
