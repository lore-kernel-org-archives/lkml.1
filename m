Return-Path: <linux-kernel-owner+w=401wt.eu-S1757220AbZEIDaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220AbZEIDaL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 23:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757427AbZEID3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 23:29:10 -0400
Received: from kroah.org ([198.145.64.141]:41358 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757356AbZEID3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 23:29:09 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Henrik Austad <henrik@austad.us>, Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/5] Doc/sysfs-rules: Swap the order of the words so the sentence makes more sense
Date: Fri,  8 May 2009 20:25:56 -0700
Message-Id: <1241839559-9157-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20090509032432.GA9000@kroah.com>
References: <20090509032432.GA9000@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Henrik Austad <henrik@austad.us>

Signed-off-by: Henrik Austad <henrik@austad.us>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/sysfs-rules.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/sysfs-rules.txt b/Documentation/sysfs-rules.txt
index 6049a2a..5d8bc2c 100644
--- a/Documentation/sysfs-rules.txt
+++ b/Documentation/sysfs-rules.txt
@@ -113,7 +113,7 @@ versions of the sysfs interface.
   "devices" directory at /sys/subsystem/<name>/devices.
 
   If /sys/subsystem exists, /sys/bus, /sys/class and /sys/block can be
-  ignored. If it does not exist, you have always to scan all three
+  ignored. If it does not exist, you always have to scan all three
   places, as the kernel is free to move a subsystem from one place to
   the other, as long as the devices are still reachable by the same
   subsystem name.
-- 
1.6.3

