Return-Path: <linux-kernel-owner+w=401wt.eu-S936904AbXLQUJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936904AbXLQUJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 15:09:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932651AbXLQTmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:42:21 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3228 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933975AbXLQTlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:41:31 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
       James Morris <jmorris@namei.org>, Patrick McHardy <kaber@trash.net>,
       coreteam@netfilter.org, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Subject: [PATCH] net/ipv4/: Spelling fixes
Date: Mon, 17 Dec 2007 11:40:31 -0800
Message-Id: <1197920439-5455-25-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918894.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 net/ipv4/netfilter/nf_nat_sip.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_sip.c b/net/ipv4/netfilter/nf_nat_sip.c
index 3ca9897..8996ccb 100644
--- a/net/ipv4/netfilter/nf_nat_sip.c
+++ b/net/ipv4/netfilter/nf_nat_sip.c
@@ -165,7 +165,7 @@ static int mangle_content_len(struct sk_buff *skb,
 
 	dataoff = ip_hdrlen(skb) + sizeof(struct udphdr);
 
-	/* Get actual SDP lenght */
+	/* Get actual SDP length */
 	if (ct_sip_get_info(ct, dptr, skb->len - dataoff, &matchoff,
 			    &matchlen, POS_SDP_HEADER) > 0) {
 
-- 
1.5.3.7.949.g2221a6

