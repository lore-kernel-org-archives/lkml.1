Return-Path: <linux-kernel-owner+w=401wt.eu-S1754918AbZAZCJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbZAZCJo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 21:09:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbZAZCJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 21:09:31 -0500
Received: from vps1.tull.net ([66.180.172.116]:50222 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752125AbZAZCJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 21:09:30 -0500
From: Nick Andrew <nick@nick-andrew.net>
Subject: [TRIVIAL PATCH 19/20] Fix misspelling of firmware in iwl3945-base.c
To: Trivial Kernel Patches <trivial@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 26 Jan 2009 13:09:22 +1100
Message-ID: <20090126020922.15168.79920.stgit@marcab.local.tull.net>
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

Fix misspelling of firmware in iwl3945-base.c

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index d645808..85e465f 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -5361,7 +5361,7 @@ static int iwl3945_read_ucode(struct iwl3945_priv *priv)
 
 	/* api_ver should match the api version forming part of the
 	 * firmware filename ... but we don't check for that and only rely
-	 * on the API version read from firware header from here on forward */
+	 * on the API version read from firmware header from here on forward */
 
 	if (api_ver < api_min || api_ver > api_max) {
 		IWL_ERROR("Driver unable to support your firmware API. "

