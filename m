Return-Path: <linux-kernel-owner+w=401wt.eu-S1760410AbZF2PD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760410AbZF2PD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 11:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760224AbZF2PCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 11:02:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:46510 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760144AbZF2PCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 11:02:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=bmS/Ri7kM1QzDZcoBfmmhqIWjnQaRRMG1h/Fxrnouyij+skpmXpheUWwBPYhpHBOPP
         mjVYMJ8s1NBV2dO5AmnOVyMgLAewOmEQlbR1KIESgfFkg2xMWe0wrbDBhFyMbHR2+h5n
         4PgF22jRMUgh7PHA0T3BDjcyWb9xn6yeNZ8NM=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, slapin@ossfans.org
Subject: [PATCH 1/3] MAINTAINERS: ieee802154 lists are moderated for non-subscribers.
Date: Mon, 29 Jun 2009 19:02:13 +0400
Message-Id: <1246287735-2692-2-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1246287735-2692-1-git-send-email-dbaryshkov@gmail.com>
References: <1246287735-2692-1-git-send-email-dbaryshkov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note that our mailing list is moderated for non-subscribers.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fa2a16d..28c150e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2886,7 +2886,7 @@ P:	Dmitry Eremin-Solenikov
 M:	dbaryshkov@gmail.com
 P:	Sergey Lapin
 M:	slapin@ossfans.org
-L:	linux-zigbee-devel@lists.sourceforge.net
+L:	linux-zigbee-devel@lists.sourceforge.net (moderated for non-subscribers)
 W:	http://apps.sourceforge.net/trac/linux-zigbee
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/lowpan/lowpan.git
 S:	Maintained
-- 
1.6.3.1

