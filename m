Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030432Ab0B0Qz5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:55:57 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41119 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030409Ab0B0Qzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:55:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=WcBSpdu969AGaHkCPI1D0RDOrLIoAzDPRoz3bAU1w3ArlEgunT5+Y1+ZMTwVdn6UQb
         tNJ7cj0z3L33cGX5aBmOTIDYDpiXQWVJxRAKn8g6cMpTJbzJuLHispguQnpeo9IvIZrO
         vsbajTKUxpJsz7e2Eq9Wc6Sv36qxvuTWVZRzg=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-kernel@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
       netfilter@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCH 40/66] include/linux/netfilter/nf_conntrack_tuple_common.h: Checkpatch cleanup
Date: Sat, 27 Feb 2010 17:51:21 +0100
Message-Id: <1267289508-31031-41-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.90.g251a4
In-Reply-To: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/linux/netfilter/nf_conntrack_tuple_common.h:5: ERROR: open brace '{' following enum go on the same line

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 .../linux/netfilter/nf_conntrack_tuple_common.h    |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_tuple_common.h b/include/linux/netfilter/nf_conntrack_tuple_common.h
index 8e145f0..2ea22b0 100644
--- a/include/linux/netfilter/nf_conntrack_tuple_common.h
+++ b/include/linux/netfilter/nf_conntrack_tuple_common.h
@@ -1,8 +1,7 @@
 #ifndef _NF_CONNTRACK_TUPLE_COMMON_H
 #define _NF_CONNTRACK_TUPLE_COMMON_H
 
-enum ip_conntrack_dir
-{
+enum ip_conntrack_dir {
 	IP_CT_DIR_ORIGINAL,
 	IP_CT_DIR_REPLY,
 	IP_CT_DIR_MAX
-- 
1.7.0.90.g251a4

