Return-Path: <linux-kernel-owner+w=401wt.eu-S1753926AbZJJGFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbZJJGFy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 02:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbZJJGFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 02:05:54 -0400
Received: from mail.perches.com ([173.55.12.10]:2055 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738AbZJJGFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 02:05:42 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Wolfram Sang <w.sang@pengutronix.de>,
       Grant Likely <grant.likely@secretlab.ca>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: [PATCH 3/3] MAINTAINERS: Add OPEN FIRMWARE DEVICE TREE section
Date: Fri,  9 Oct 2009 23:05:04 -0700
Message-Id: <774db7b9d6083108e254a3c8bbdb17251bf3b45c.1255153863.git.joe@perches.com>
X-Mailer: git-send-email 1.6.5.rc3.dirty
In-Reply-To: <cover.1255153863.git.joe@perches.com>
References: <cover.1255153863.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added L: mailing list, W: wiki and K: of_get_property keyword

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4407de2..a88ea6b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3884,6 +3884,12 @@ S:	Maintained
 F:	Documentation/i2c/busses/i2c-ocores
 F:	drivers/i2c/busses/i2c-ocores.c
 
+OPEN FIRMWARE DEVICE TREE
+L:	devicetree-discuss@lists.ozlabs.org
+W:	http://fdt.secretlab.ca/Main_Page
+S:	Odd Fixes
+K:	of_get_property
+
 OPROFILE
 M:	Robert Richter <robert.richter@amd.com>
 L:	oprofile-list@lists.sf.net
-- 
1.6.5.rc3.dirty

