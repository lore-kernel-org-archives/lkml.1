Return-Path: <linux-kernel-owner+w=401wt.eu-S1762391AbXE1Im4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762391AbXE1Im4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 04:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761534AbXE1Ig5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 04:36:57 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:43596 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760071AbXE1Igh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 04:36:37 -0400
X-IronPort-AV: i="4.14,586,1170651600"; 
   d="scan'208"; a="40300059:sNHT20786360"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>, Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH 17/20] Blackfin RTC drivers: update MAINTAINERS information
Date: Mon, 28 May 2007 16:37:52 +0800
Message-Id: <1180341480677-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <11803414753217-git-send-email-bryan.wu@analog.com>
References: <11803414753217-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
---
 MAINTAINERS |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 57dd23a..0736b64 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -752,6 +752,14 @@ L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
 W:	http://blackfin.uclinux.org
 S:	Supported
 
+BLACKFIN RTC DRIVER
+P:	Mike Frysinger
+M:	michael.frysinger@analog.com
+M:	vapier.adi@gmail.com
+L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
+W:	http://blackfin.uclinux.org
+S:	Supported
+
 BLACKFIN SERIAL DRIVER
 P:	Aubrey Li
 M:	aubrey.li@analog.com
-- 
1.5.2
