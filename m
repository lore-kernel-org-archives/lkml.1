Return-Path: <linux-kernel-owner+w=401wt.eu-S932931AbZJ3V04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931AbZJ3V04 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 17:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932919AbZJ3V0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 17:26:55 -0400
Received: from 139.254.232.72.static.reverse.ltdomains.com ([72.232.254.139]:45413
	"EHLO liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932916AbZJ3V0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 17:26:54 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: trivial@kernel.org
Cc: Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH] trivial: fix a typo in SHM_SIGNAL config description
Date: Fri, 30 Oct 2009 19:26:52 -0200
Message-Id: <1256938012-8088-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 lib/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/Kconfig b/lib/Kconfig
index 272cecf..bfe871d 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -207,7 +207,7 @@ config SHM_SIGNAL
 	tristate "SHM Signal - Generic shared-memory signaling mechanism"
 	default n
 	help
-	 Provides a shared-memory based signaling mechansim to indicate
+	 Provides a shared-memory based signaling mechanism to indicate
          memory-dirty notifications between two end-points.
 
 	 If unsure, say N
-- 
1.6.3.3

