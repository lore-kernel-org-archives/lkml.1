Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008AbZJQXrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbZJQXrD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 19:47:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbZJQXrC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 19:47:02 -0400
Received: from mail.perches.com ([173.55.12.10]:2246 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbZJQXrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 19:47:01 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] MAINTAINERS: SERVER ENGINES 10Gbps iSCSI - Use single line M:
Date: Sat, 17 Oct 2009 16:47:03 -0700
Message-Id: <7631cce3b880e995df3dca58666217730a393ddc.1255822797.git.joe@perches.com>
X-Mailer: git-send-email 1.6.5.rc3.dirty
In-Reply-To: <cover.1255822797.git.joe@perches.com>
References: <cover.1255822797.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Integrate P:/M: lines to single M:
Use tabs not spaces

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7f3dca7..e0a3e52 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4666,12 +4666,11 @@ F:	include/linux/ata.h
 F:	include/linux/libata.h
 
 SERVER ENGINES 10Gbps iSCSI - BladeEngine 2 DRIVER
-P:     Jayamohan Kallickal
-M:     jayamohank@serverengines.com
-L:     linux-scsi@vger.kernel.org
-W:     http://www.serverengines.com
-S:     Supported
-F:     drivers/scsi/be2iscsi/
+M:	Jayamohan Kallickal <jayamohank@serverengines.com>
+L:	linux-scsi@vger.kernel.org
+W:	http://www.serverengines.com
+S:	Supported
+F:	drivers/scsi/be2iscsi/
 
 SERVER ENGINES 10Gbps NIC - BladeEngine 2 DRIVER
 M:	Sathya Perla <sathyap@serverengines.com>
-- 
1.6.5.rc3.dirty

