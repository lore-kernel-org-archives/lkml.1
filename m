Return-Path: <linux-kernel-owner+w=401wt.eu-S939821AbXHMKmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939821AbXHMKmF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:42:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967328AbXHMGgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:36:19 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1850 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967281AbXHMGgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:36:14 -0400
Date: Sun, 12 Aug 2007 23:22:33 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, r.marek@assembler.cz,
       linux-kernel@vger.kernel.org, i2c@lm-sensors.org,
       akpm@linux-foundation.org
Subject: [PATCH] [37/2many] MAINTAINERS - ALI1563 I2C DRIVER
Message-ID: <46bff8a9.FJdmih5x59gs5DLA%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 3a586da..eeb1bf9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -367,6 +367,7 @@ P:	Rudolf Marek
 M:	r.marek@assembler.cz
 L:	i2c@lm-sensors.org
 S:	Maintained
+F:	drivers/i2c/busses/i2c-ali1563.c
 
 ALPHA PORT
 P:	Richard Henderson
