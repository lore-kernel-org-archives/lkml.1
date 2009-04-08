Return-Path: <linux-kernel-owner+w=401wt.eu-S1760467AbZDHFWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760467AbZDHFWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 01:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759947AbZDHFU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 01:20:27 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4368 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759817AbZDHFUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 01:20:21 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/10] MAINTAINERS - i2c_tiny_usb T: should be W:
Date: Tue,  7 Apr 2009 22:17:49 -0700
Message-Id: <1239167872-8179-8-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1239167872-8179-1-git-send-email-joe@perches.com>
References: <1239167872-8179-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 47068c4..dfc78fb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2653,7 +2653,7 @@ I2C-TINY-USB DRIVER
 P:	Till Harbaum
 M:	till@harbaum.org
 L:	linux-i2c@vger.kernel.org
-T:	http://www.harbaum.org/till/i2c_tiny_usb
+W:	http://www.harbaum.org/till/i2c_tiny_usb
 S:	Maintained
 F:	drivers/i2c/busses/i2c-tiny-usb.c
 
-- 
1.6.0.2

