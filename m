Return-Path: <linux-kernel-owner+w=401wt.eu-S1753516AbZAZCE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbZAZCE1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 21:04:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751231AbZAZCER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 21:04:17 -0500
Received: from vps1.tull.net ([66.180.172.116]:50688 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751167AbZAZCEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 21:04:15 -0500
From: Nick Andrew <nick@nick-andrew.net>
Subject: [TRIVIAL PATCH 09/20] Fix misspelling of firmware in cmd.c
To: Trivial Kernel Patches <trivial@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 26 Jan 2009 13:04:08 +1100
Message-ID: <20090126020408.15168.35666.stgit@marcab.local.tull.net>
In-Reply-To: <20090126015921.15168.97302.stgit@marcab.local.tull.net>
References: <20090126015921.15168.97302.stgit@marcab.local.tull.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix misspelling of firmware in cmd.c

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 drivers/net/wireless/libertas/cmd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 639dd02..8c3605c 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1649,7 +1649,7 @@ static struct cmd_ctrl_node *lbs_get_cmd_ctrl_node(struct lbs_private *priv)
 
 /**
  *  @brief This function executes next command in command
- *  pending queue. It will put fimware back to PS mode
+ *  pending queue. It will put firmware back to PS mode
  *  if applicable.
  *
  *  @param priv     A pointer to struct lbs_private structure

