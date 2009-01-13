Return-Path: <linux-kernel-owner+w=401wt.eu-S1756559AbZAMUar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbZAMUar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 15:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758552AbZAMU1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 15:27:53 -0500
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2536 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756901AbZAMU1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 15:27:50 -0500
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 09/10] MAINTAINERS - i2c_tiny_usb T: should be W:
Date: Tue, 13 Jan 2009 12:28:17 -0800
Message-Id: <1231878498-25171-10-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1231878498-25171-1-git-send-email-joe@perches.com>
References: <1231878498-25171-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6e051c3..221c944 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2549,7 +2549,7 @@ I2C-TINY-USB DRIVER
 P:	Till Harbaum
 M:	till@harbaum.org
 L:	linux-i2c@vger.kernel.org
-T:	http://www.harbaum.org/till/i2c_tiny_usb
+W:	http://www.harbaum.org/till/i2c_tiny_usb
 S:	Maintained
 F:	drivers/i2c/busses/i2c-tiny-usb.c
 
-- 
1.6.0.2

