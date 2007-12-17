Return-Path: <linux-kernel-owner+w=401wt.eu-S1757771AbXLQUH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771AbXLQUH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 15:07:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932949AbXLQTmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:42:09 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3237 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934011AbXLQTle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:41:34 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Patrick McHardy <kaber@trash.net>, coreteam@netfilter.org,
       netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
       netfilter@vger.kernel.org
Subject: [PATCH] net/netfilter/: Spelling fixes
Date: Mon, 17 Dec 2007 11:40:34 -0800
Message-Id: <1197920439-5455-28-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918894.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 net/netfilter/nf_conntrack_sip.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 8f8b5a4..515abff 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -187,7 +187,7 @@ static const struct sip_header_nfo ct_sip_hdrs[] = {
 	}
 };
 
-/* get line lenght until first CR or LF seen. */
+/* get line length until first CR or LF seen. */
 int ct_sip_lnlen(const char *line, const char *limit)
 {
 	const char *k = line;
@@ -236,7 +236,7 @@ static int digits_len(struct nf_conn *ct, const char *dptr,
 	return len;
 }
 
-/* get digits lenght, skiping blank spaces. */
+/* get digits length, skipping blank spaces. */
 static int skp_digits_len(struct nf_conn *ct, const char *dptr,
 			  const char *limit, int *shift)
 {
-- 
1.5.3.7.949.g2221a6

