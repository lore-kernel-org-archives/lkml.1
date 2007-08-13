Return-Path: <linux-kernel-owner+w=401wt.eu-S970974AbXHMMX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970974AbXHMMX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966546AbXHMGrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:47:03 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2566 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967976AbXHMGrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:47:00 -0400
Date: Sun, 12 Aug 2007 23:33:25 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, olof@lixom.net,
       linux-kernel@vger.kernel.org, i2c@lm-sensors.org,
       akpm@linux-foundation.org
Subject: [PATCH] [362/2many] MAINTAINERS - PA SEMI SMBUS DRIVER
Message-ID: <46bffb35.6zRcCKY0WBoOyDNN%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index c488769..21a427e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3477,6 +3477,7 @@ P:	Olof Johansson
 M:	olof@lixom.net
 L:	i2c@lm-sensors.org
 S:	Maintained
+F:	drivers/i2c/busses/i2c-pasemi.c
 
 PARALLEL PORT SUPPORT
 L:	linux-parport@lists.infradead.org (subscribers-only)
