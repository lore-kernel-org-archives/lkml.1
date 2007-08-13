Return-Path: <linux-kernel-owner+w=401wt.eu-S971223AbXHMMWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971223AbXHMMWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967926AbXHMGqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:46:46 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2559 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967884AbXHMGqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:46:45 -0400
Date: Sun, 12 Aug 2007 23:33:04 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jacmet@sunsite.dk, i2c@lm-sensors.org, akpm@linux-foundation.org
Subject: [PATCH] [351/2many] MAINTAINERS - OPENCORES I2C BUS DRIVER
Message-ID: <46bffb20.vHjX4gSllF0mkokd%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 9e9775a..14a983d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3381,6 +3381,8 @@ P:	Peter Korsgaard
 M:	jacmet@sunsite.dk
 L:	i2c@lm-sensors.org
 S:	Maintained
+F:	Documentation/i2c/busses/i2c-ocores
+F:	drivers/i2c/busses/i2c-ocores.c
 
 ORACLE CLUSTER FILESYSTEM 2 (OCFS2)
 P:	Mark Fasheh
