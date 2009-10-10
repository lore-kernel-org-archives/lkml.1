Return-Path: <linux-kernel-owner+w=401wt.eu-S1754256AbZJJGe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbZJJGe5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 02:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbZJJGez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 02:34:55 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:46527 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbZJJGey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 02:34:54 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] Add Open Firmware / Flattened Device Tree entry to maintainers
To: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Wolfram Sang <w.sang@pengutronix.de>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       devicetree-discuss@lists.ozlabs.org
Date: Sat, 10 Oct 2009 00:33:43 -0600
Message-ID: <20091010063334.6432.57743.stgit@angua>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 MAINTAINERS |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 09a2028..7c801b0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3869,6 +3869,15 @@ S:	Maintained
 F:	Documentation/i2c/busses/i2c-ocores
 F:	drivers/i2c/busses/i2c-ocores.c
 
+OPEN FIRMWARE AND FLATTENED DEVICE TREE
+M:	Grant Likely <grant.likely@secretlab.ca>
+L:	devicetree-discuss@lists.ozlabs.org
+W:	http://fdt.secretlab.ca
+S:	Maintained
+F:	drivers/of
+F:	include/linux/of*.h
+K:	of_get_property
+
 OPROFILE
 M:	Robert Richter <robert.richter@amd.com>
 L:	oprofile-list@lists.sf.net

