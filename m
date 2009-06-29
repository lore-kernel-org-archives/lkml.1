Return-Path: <linux-kernel-owner+w=401wt.eu-S1760319AbZF2PDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760319AbZF2PDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 11:03:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760227AbZF2PCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 11:02:43 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:36258 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760169AbZF2PCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 11:02:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qTiIlxz7ZNH8pcNfwSw/YtKumgD/pni6mzUwQOw2aVGUgY8ojAk/ZdUOS19nO0pRgq
         m5tmjFVXMNRh9WSFBysFPNbRlZaZmzYBF2STmNWI2I6Mh5ebPgCbgOmKxqi5eMQRIJ3W
         qafefCC/M99inGy4Rid9d+qiwD+VBRm7BaiNc=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, slapin@ossfans.org
Subject: [PATCH 3/3] nl802154: add module license and description
Date: Mon, 29 Jun 2009 19:02:15 +0400
Message-Id: <1246287735-2692-4-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1246287735-2692-3-git-send-email-dbaryshkov@gmail.com>
References: <1246287735-2692-1-git-send-email-dbaryshkov@gmail.com>
 <1246287735-2692-2-git-send-email-dbaryshkov@gmail.com>
 <1246287735-2692-3-git-send-email-dbaryshkov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 net/ieee802154/netlink.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/ieee802154/netlink.c b/net/ieee802154/netlink.c
index 332b947..27eda9f 100644
--- a/net/ieee802154/netlink.c
+++ b/net/ieee802154/netlink.c
@@ -524,3 +524,6 @@ static void __exit ieee802154_nl_exit(void)
 }
 module_exit(ieee802154_nl_exit);
 
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("ieee 802.15.4 configuration interface");
+
-- 
1.6.3.1

