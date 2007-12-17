Return-Path: <linux-kernel-owner+w=401wt.eu-S1762448AbXLQTmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762448AbXLQTmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:42:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757915AbXLQTbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:31:53 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2993 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761141AbXLQTbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:31:44 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Chas Williams <chas@cmf.nrl.navy.mil>
Subject: [PATCH] drivers/atm/: Spelling fixes
Date: Mon, 17 Dec 2007 11:30:28 -0800
Message-Id: <1197919875-5288-29-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918890.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/atm/firestream.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/atm/firestream.c b/drivers/atm/firestream.c
index f8f7139..c662d68 100644
--- a/drivers/atm/firestream.c
+++ b/drivers/atm/firestream.c
@@ -171,8 +171,8 @@ static char *res_strings[] = {
 	"packet purged", 
 	"packet ageing timeout", 
 	"channel ageing timeout", 
-	"calculated lenght error", 
-	"programmed lenght limit error", 
+	"calculated length error", 
+	"programmed length limit error", 
 	"aal5 crc32 error", 
 	"oam transp or transpc crc10 error", 
 	"reserved 25", 
-- 
1.5.3.7.949.g2221a6

