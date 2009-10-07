Return-Path: <linux-kernel-owner+w=401wt.eu-S1757776AbZJGGS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776AbZJGGS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 02:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757023AbZJGGS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 02:18:56 -0400
Received: from mailout5.samsung.com ([203.254.224.35]:64463 "EHLO
	mailout5.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756294AbZJGGSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 02:18:54 -0400
Date: Wed, 07 Oct 2009 15:18:05 +0900
From: Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 3/6] Haptic: Add haptic maintainer
To: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Cc: soni.trilok@gmail.com
Message-id: <20091007061805.GA7592@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-OriginalArrivalTime: 07 Oct 2009 06:18:12.0145 (UTC)
 FILETIME=[F27A0A10:01CA4715]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add me to haptic class maintainer

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 MAINTAINERS |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 09a2028..906b603 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2287,6 +2287,13 @@ F:	Documentation/isdn/README.gigaset
 F:	drivers/isdn/gigaset/
 F:	include/linux/gigaset_dev.h
 
+HAPTIC SUBSYSTEM
+M:	Kyungmin Park <kyungmin.park@samsung.com>
+L:	linux-input@vger.kernel.org
+S:	Maintained
+F:	drivers/haptic/
+F:	include/linux/haptic.h
+
 HARD DRIVE ACTIVE PROTECTION SYSTEM (HDAPS) DRIVER
 M:	Frank Seidel <frank@f-seidel.de>
 L:	lm-sensors@lm-sensors.org
-- 
1.5.3.3

