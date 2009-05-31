Return-Path: <linux-kernel-owner+w=401wt.eu-S1753135AbZEaXvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbZEaXvX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 19:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbZEaXvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 19:51:16 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:60386 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbZEaXvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 19:51:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:organization:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qW+OazXNoYMmKUdR2rK3bZ4b9AGVexYTA7PV9ebkSPuOtPgVz3nGYJpqvsJX3qUyS2
         XPebc+1o3bKSQ7rFqdStGqnGFzHl//zc5WUQI7vSf8TlgVVFRGqQe8ohdpcUVe6miCAK
         SmVXd0YRA51HSEKEUdUycBT62xSWdaGdjVyCo=
Subject: [PATCH] ftrace:fix description of trace directory
From: GeunSik Lim <leemgs1@gmail.com>
Reply-To: leemgs1@gmail.com
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain
Organization: Private
Date: Mon, 01 Jun 2009 08:51:09 +0900
Message-Id: <1243813869.20635.34.camel@centos51>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi Jiri Kosina,

This is trivial patch.

Thanks.


Subject: [PATCH] ftrace:fix description of trace directory

Fix trace source directory from kernel/tracing/ to kernel/trace/.
      Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>

---
 Documentation/trace/ftrace.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index fd9a3e6..608770c 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -1825,4 +1825,4 @@ an error.
 -----------
 
 More details can be found in the source code, in the
-kernel/tracing/*.c files.
+kernel/trace/*.c files.
-- 
1.6.3.1



-----------------------------------------------
To unsubscribe from this list: send the line "unsubscribe linux-***" 
in the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

GeunSik Lim (  S A M S U N G     E L E C T R O N I C S  )
e-Mail  :1) geunsik.lim@samsung.com
         2) leemgs@gmail.com , leemgs1@gmail.com
HomePage: http://blog.naver.com/invain/
-----------------------------------------------

