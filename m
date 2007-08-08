Return-Path: <linux-kernel-owner+w=401wt.eu-S936934AbXHHDj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936934AbXHHDj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 23:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935995AbXHHDg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 23:36:27 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:9964 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934401AbXHHDfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 23:35:51 -0400
X-IronPort-AV: i="4.19,233,1183348800"; 
   d="scan'208"; a="36639271:sNHT1204641494"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Cc: dbrownell@users.sourceforge.net,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 05/12] Blackfin arch: Advertise GENERIC_GPIO and remove duplicated GENERIC_CALIBRATE_DELAY
Date: Wed,  8 Aug 2007 11:35:30 +0800
Message-Id: <1186544140767-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <11865441373719-git-send-email-bryan.wu@analog.com>
References: <11865441373719-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 017defa..5c1e215 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -57,7 +57,7 @@ config GENERIC_TIME
 	bool
 	default n
 
-config GENERIC_CALIBRATE_DELAY
+config GENERIC_GPIO
 	bool
 	default y
 
-- 
1.5.2
