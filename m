Return-Path: <linux-kernel-owner+w=401wt.eu-S1754468AbXLDNWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468AbXLDNWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 08:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754100AbXLDNWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 08:22:22 -0500
Received: from mail164.messagelabs.com ([216.82.253.131]:62314 "HELO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754131AbXLDNWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 08:22:20 -0500
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-4.tower-164.messagelabs.com!1196774538!10241004!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.21]
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, David Woodhouse <dwmw2@shinybook.infradead.org>
Subject: [PATCH] grammar fix
Date: Tue,  4 Dec 2007 14:22:15 +0100
Message-Id: <1196774535-11782-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
X-Mailer: git-send-email 1.5.3.6
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 04 Dec 2007 13:22:15.0316 (UTC) FILETIME=[AFC81540:01C83678]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.000.1023-15584.003
X-TM-AS-Result: No--4.157400-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was introduced in 4af8e944c22d8af92a7548354a9567250cc1a782

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
Cc: David Woodhouse <dwmw2@shinybook.infradead.org>
---
 fs/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 635f3e2..487236c 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1305,7 +1305,7 @@ config JFFS2_COMPRESSION_OPTIONS
 	help
 	  Enabling this option allows you to explicitly choose which
 	  compression modules, if any, are enabled in JFFS2. Removing
-	  compressors and mean you cannot read existing file systems,
+	  compressors can mean you cannot read existing file systems,
 	  and enabling experimental compressors can mean that you
 	  write a file system which cannot be read by a standard kernel.
 
-- 
1.5.3.6

