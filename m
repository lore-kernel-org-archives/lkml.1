Return-Path: <linux-kernel-owner+w=401wt.eu-S967825AbXHMGnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967825AbXHMGnA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757548AbXHMGXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:23:03 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3565 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965802AbXHMGW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:22:57 -0400
Date: Sun, 12 Aug 2007 23:22:42 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, tom@opengridcomputing.com,
       swise@opengridcomputing.com, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org, akpm@linux-foundation.org
Subject: [PATCH] [42/2many] MAINTAINERS - AMSO1100 RNIC DRIVER
Message-ID: <46bff8b2.WLKhHT0C2uIfdSf+%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 635d812..e2e88f3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -412,6 +412,7 @@ P:	Steve Wise
 M:	swise@opengridcomputing.com
 L:	general@lists.openfabrics.org
 S:	Maintained
+F:	drivers/infiniband/hw/amso1100/
 
 AOA (Apple Onboard Audio) ALSA DRIVER
 P:	Johannes Berg
