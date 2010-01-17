Return-Path: <linux-kernel-owner+w=401wt.eu-S1755004Ab0AQVaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab0AQVaP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 16:30:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754965Ab0AQVaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 16:30:13 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:36253 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887Ab0AQVaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 16:30:05 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: trivial@kernel.org
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
       linux-doc@vger.kernel.org
Subject: [PATCH] trivial: fix typo s/Defaultd/Defaults/ in EISA documentation
Date: Sun, 17 Jan 2010 19:27:32 -0200
Message-Id: <1263763653-9774-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 Documentation/eisa.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/eisa.txt b/Documentation/eisa.txt
index 60e361b..f297fc1 100644
--- a/Documentation/eisa.txt
+++ b/Documentation/eisa.txt
@@ -171,7 +171,7 @@ device.
 virtual_root.force_probe :
 
 Force the probing code to probe EISA slots even when it cannot find an
-EISA compliant mainboard (nothing appears on slot 0). Defaultd to 0
+EISA compliant mainboard (nothing appears on slot 0). Defaults to 0
 (don't force), and set to 1 (force probing) when either
 CONFIG_ALPHA_JENSEN or CONFIG_EISA_VLB_PRIMING are set.
 
-- 
1.6.6

