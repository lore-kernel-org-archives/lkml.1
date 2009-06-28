Return-Path: <linux-kernel-owner+w=401wt.eu-S1758939AbZF1QfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbZF1QfS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757060AbZF1Q1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:27:55 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1139 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756857AbZF1Q1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:27:51 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-pcmcia@lists.infradead.org
Subject: [PATCH 36/62] drivers/pcmcia/pcmcia_resource.c: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:41 -0700
Message-Id: <44c4765b1f7328b00ac1468dab3baa9acd658873.1246173682.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/pcmcia/pcmcia_resource.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pcmcia/pcmcia_resource.c b/drivers/pcmcia/pcmcia_resource.c
index f5d0ba8..8c2db2a 100644
--- a/drivers/pcmcia/pcmcia_resource.c
+++ b/drivers/pcmcia/pcmcia_resource.c
@@ -489,7 +489,7 @@ int pcmcia_request_configuration(struct pcmcia_device *p_dev,
 	pccard_io_map iomap;
 
 	if (!(s->state & SOCKET_PRESENT))
-		return -ENODEV;;
+		return -ENODEV;
 
 	if (req->IntType & INT_CARDBUS) {
 		ds_dbg(p_dev->socket, 0, "IntType may not be INT_CARDBUS\n");
-- 
1.6.3.1.10.g659a0.dirty

