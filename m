Return-Path: <linux-kernel-owner+w=401wt.eu-S1759866AbZF1Qlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759866AbZF1Qlm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756622AbZF1Q2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:28:38 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1184 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132AbZF1Q2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:28:20 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Steve French <sfrench@samba.org>, samba-technical@lists.samba.org,
       linux-cifs-client@lists.samba.org
Subject: [PATCH 56/62] fs/cifs/cifs_dfs_ref.c: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:27:01 -0700
Message-Id: <33feb04c647d39629feb6252488214b05e297f44.1246173683.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/cifs/cifs_dfs_ref.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index 3bb11be..3f2c2a3 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -136,7 +136,7 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
 	rc = dns_resolve_server_name_to_ip(*devname, &srvIP);
 	if (rc != 0) {
 		cERROR(1, ("%s: Failed to resolve server part of %s to IP: %d",
-			  __func__, *devname, rc));;
+			  __func__, *devname, rc));
 		goto compose_mount_options_err;
 	}
 	/* md_len = strlen(...) + 12 for 'sep+prefixpath='
-- 
1.6.3.1.10.g659a0.dirty

