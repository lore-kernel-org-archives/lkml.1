Return-Path: <linux-kernel-owner+w=401wt.eu-S932074AbZGMVRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074AbZGMVRQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 17:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757434AbZGMVRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 17:17:05 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4016 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757292AbZGMVPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 17:15:05 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 08/16] MAINTAINERS: Add PPS patterns
Date: Mon, 13 Jul 2009 14:14:54 -0700
Message-Id: <e8ff02818bc16889321cbbb804f59cae290ee0eb.1247517374.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1247517373.git.joe@perches.com>
References: <cover.1247517373.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 108ae11..3bb2c93 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4659,6 +4659,9 @@ M:	giometti@enneenne.com
 W:	http://wiki.enneenne.com/index.php/LinuxPPS_support
 L:	linuxpps@ml.enneenne.com (subscribers-only)
 S:	Maintained
+F:	Documentation/pps/
+F:	drivers/pps/
+F:	include/linux/pps*.h
 
 PREEMPTIBLE KERNEL
 P:	Robert Love
-- 
1.6.3.1.10.g659a0.dirty

