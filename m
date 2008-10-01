Return-Path: <linux-kernel-owner+w=401wt.eu-S1755150AbYJAJEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150AbYJAJEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 05:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754327AbYJAI6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 04:58:32 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:58013 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551AbYJAI6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 04:58:31 -0400
Message-Id: <20081001084126.516224293@de.ibm.com>
References: <20081001083317.782967473@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 01 Oct 2008 10:33:22 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 05/21] cio: Exorcise cio_msg= from documentation.
Content-Disposition: inline; filename=104-cio-msg.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 Documentation/s390/CommonIO |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: quilt-2.6/Documentation/s390/CommonIO
===================================================================
--- quilt-2.6.orig/Documentation/s390/CommonIO
+++ quilt-2.6/Documentation/s390/CommonIO
@@ -104,8 +104,7 @@ debugfs entries
     handling).
 
   - /sys/kernel/debug/s390dbf/cio_msg/sprintf
-    Various debug messages from the common I/O-layer, including messages
-    printed when cio_msg=yes.
+    Various debug messages from the common I/O-layer.
 
   - /sys/kernel/debug/s390dbf/cio_trace/hex_ascii
     Logs the calling of functions in the common I/O-layer and, if applicable, 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

