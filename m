Return-Path: <linux-kernel-owner+w=401wt.eu-S1753693AbZCQXV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbZCQXV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 19:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685AbZCQXUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 19:20:54 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4382 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbZCQXUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 19:20:54 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 7/8] MAINTAINERS - i2c_tiny_usb T: should be W:
Date: Tue, 17 Mar 2009 16:19:28 -0700
Message-Id: <1237331969-28565-8-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1237331969-28565-1-git-send-email-joe@perches.com>
References: <1237331969-28565-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a7d47b7..674158b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2594,7 +2594,7 @@ I2C-TINY-USB DRIVER
 P:	Till Harbaum
 M:	till@harbaum.org
 L:	linux-i2c@vger.kernel.org
-T:	http://www.harbaum.org/till/i2c_tiny_usb
+W:	http://www.harbaum.org/till/i2c_tiny_usb
 S:	Maintained
 F:	drivers/i2c/busses/i2c-tiny-usb.c
 
-- 
1.6.0.2

