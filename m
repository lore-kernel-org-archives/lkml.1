Return-Path: <linux-kernel-owner+w=401wt.eu-S1755299AbZDUBmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbZDUBmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 21:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbZDUBmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 21:42:00 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:43213 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbZDUBl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 21:41:59 -0400
Date: Mon, 20 Apr 2009 18:42:38 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: gregkh@suse.de, Henrik Austad <henrik@austad.us>
Subject: [PATCH] Doc/sysfs-rules: Swap the order of the words so the
 sentence makes more sense
Message-Id: <20090420184238.51cd7092.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010204.49ED2458.0124:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Henrik Austad <henrik@austad.us>
Subject: Swap the order of the words so the sentence makes more sense

Signed-off-by: Henrik Austad <henrik@austad.us>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
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
