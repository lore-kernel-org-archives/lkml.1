Return-Path: <linux-kernel-owner+w=401wt.eu-S935387AbZJOTr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935387AbZJOTr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 15:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935378AbZJOTr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 15:47:56 -0400
Received: from 139.254.232.72.static.reverse.ltdomains.com ([72.232.254.139]:53040
	"EHLO liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935309AbZJOTrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 15:47:55 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: trivial@kernel.org
Cc: akpm@linux-foundation.org, miltonm@austin.ibm.com,
       manfred@colorfullife.com, penbergs@cs.helsinki.fi,
       bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH 3/8] trivial: fix typo s/ide/id/
Date: Thu, 15 Oct 2009 16:47:08 -0300
Message-Id: <1255636028-5779-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 lib/idr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index 80ca9ac..1cac726 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -281,7 +281,7 @@ static int idr_get_new_above_int(struct idr *idp, void *ptr, int starting_id)
 /**
  * idr_get_new_above - allocate new idr entry above or equal to a start id
  * @idp: idr handle
- * @ptr: pointer you want associated with the ide
+ * @ptr: pointer you want associated with the id
  * @start_id: id to start search at
  * @id: pointer to the allocated handle
  *
@@ -313,7 +313,7 @@ EXPORT_SYMBOL(idr_get_new_above);
 /**
  * idr_get_new - allocate new idr entry
  * @idp: idr handle
- * @ptr: pointer you want associated with the ide
+ * @ptr: pointer you want associated with the id
  * @id: pointer to the allocated handle
  *
  * This is the allocate id function.  It should be called with any
-- 
1.6.3.3

