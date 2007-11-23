Return-Path: <linux-kernel-owner+w=401wt.eu-S1756735AbXKWKL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735AbXKWKL6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 05:11:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756859AbXKWKKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 05:10:38 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:4875 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756936AbXKWKKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 05:10:37 -0500
X-IronPort-AV: i="4.21,455,1188792000"; 
   d="scan'208"; a="44107214:sNHT32088560"
From: Bryan Wu <bryan.wu@analog.com>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 1/1] MAINTIANERS: just use Mike gmail e-mail for contact and pawn the serial driver off onto Sonic
Date: Fri, 23 Nov 2007 18:10:29 +0800
Message-Id: <1195812629-26138-1-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 MAINTAINERS |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index cad0882..5c4b7c3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -755,22 +755,20 @@ S:	Supported
 
 BLACKFIN RTC DRIVER
 P:	Mike Frysinger
-M:	michael.frysinger@analog.com
 M:	vapier.adi@gmail.com
 L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
 W:	http://blackfin.uclinux.org
 S:	Supported
 
 BLACKFIN SERIAL DRIVER
-P:	Aubrey Li
-M:	aubrey.li@analog.com
+P:	Sonic Zhang
+M:	sonic.zhang@analog.com
 L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
 W:	http://blackfin.uclinux.org
 S:	Supported
 
 BLACKFIN WATCHDOG DRIVER
 P:	Mike Frysinger
-M:	michael.frysinger@analog.com
 M:	vapier.adi@gmail.com
 L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
 W:	http://blackfin.uclinux.org
-- 
1.5.3.4
