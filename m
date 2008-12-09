Return-Path: <linux-kernel-owner+w=401wt.eu-S1755552AbYLIXgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbYLIXgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 18:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbYLIXgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 18:36:41 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:52622 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbYLIXgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 18:36:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=E4XqkLTunVQDdMzpROhkzLuQ3obyN7cMUXf2lOlI3i9sy07VE3EmWgswptIRDz7QOZ
         +wGz1MwuJ8J3/zujtBDJIYfPC6a0v0Q3qp3h62oLBtyfxT3YWsyFA8bkvt5KFSi5tsKk
         aaQF+rEpAoyyAyj4WN+JiQRBJTGO1oe44Iprc=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Subject: [PATCH] Change my surname to reflect it's RL change
Date: Wed, 10 Dec 2008 02:35:08 +0300
Message-Id: <1228865708-12789-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My surname has changed due to marriage. Change MAINTAINERS entry
and add .mailmap entry to reflect that.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 .mailmap    |    1 +
 MAINTAINERS |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/.mailmap b/.mailmap
index 97f7b4f..4e83e7b 100644
--- a/.mailmap
+++ b/.mailmap
@@ -32,6 +32,7 @@ Christoph Hellwig <hch@lst.de>
 Corey Minyard <minyard@acm.org>
 David Brownell <david-b@pacbell.net>
 David Woodhouse <dwmw2@shinybook.infradead.org>
+Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
 Domen Puncer <domen@coderock.org>
 Douglas Gilbert <dougg@torque.net>
 Ed L. Cashin <ecashin@coraid.com>
diff --git a/MAINTAINERS b/MAINTAINERS
index 618c1ef..b52b3e5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -616,7 +616,7 @@ M:	mkpetch@internode.on.net
 S:	Maintained
 
 ARM/TOSA MACHINE SUPPORT
-P:	Dmitry Baryshkov
+P:	Dmitry Eremin-Solenikov
 M:	dbaryshkov@gmail.com
 P:	Dirk Opfer
 M:	dirk@opfer-online.de
-- 
1.5.6.5

