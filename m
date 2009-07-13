Return-Path: <linux-kernel-owner+w=401wt.eu-S1757329AbZGMVRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbZGMVRo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 17:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757359AbZGMVRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 17:17:04 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4018 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbZGMVPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 17:15:05 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 09/16] MAINTAINERS: USB Serial Digi Acceleport: use separate P: for Al Borchers
Date: Mon, 13 Jul 2009 14:14:55 -0700
Message-Id: <f686e06e0eab7dbe56335f58b9e1061abf7d457a.1247517374.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1247517373.git.joe@perches.com>
References: <cover.1247517373.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3bb2c93..4f6b5e0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6098,8 +6098,9 @@ S:	Maintained
 F:	drivers/usb/serial/cyberjack.c
 
 USB SERIAL DIGI ACCELEPORT DRIVER
-P:	Peter Berger and Al Borchers
+P:	Peter Berger
 M:	pberger@brimson.com
+P:	Al Borchers
 M:	alborchers@steinerpoint.com
 L:	linux-usb@vger.kernel.org
 S:	Maintained
-- 
1.6.3.1.10.g659a0.dirty

