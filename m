Return-Path: <linux-kernel-owner+w=401wt.eu-S1753402AbYAXMmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbYAXMmQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 07:42:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753657AbYAXMmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 07:42:03 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:65482 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752863AbYAXMmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 07:42:01 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Victor <linux@maxim.org.za>, Remy Bohmer <linux@bohmer.net>,
       Chip Coldwell <coldwell@redhat.com>, Marc Pignat <marc.pignat@hevs.ch>,
       David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH -mm v4 1/9] MAINTAINERS: Add myself as maintainer of the atmel_serial driver
Date: Thu, 24 Jan 2008 13:41:43 +0100
Message-Id: <1201178511-12133-2-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1201178511-12133-1-git-send-email-hskinnemoen@atmel.com>
References: <1201178511-12133-1-git-send-email-hskinnemoen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The atmel_serial driver never had a MAINTAINERS entry, although Andrew
Victor has effectively been acting as a maintainer since he got the
driver merged into mainline in the first place.

I'll keep Cc'ing Andrew on all patches, but I'm going to take the
main responsibility for getting things moving upstream from now on.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Acked-by: Andrew Victor <linux@maxim.org.za>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2340cfb..e349a9e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -671,6 +671,12 @@ W:	http://www.atmel.com/products/AT91/
 W:	http://www.at91.com/
 S:	Maintained
 
+ATMEL AT91 / AT32 SERIAL DRIVER
+P:	Haavard Skinnemoen
+M:	hskinnemoen@atmel.com
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+
 ATMEL LCDFB DRIVER
 P:	Nicolas Ferre
 M:	nicolas.ferre@atmel.com
-- 
1.5.3.8

