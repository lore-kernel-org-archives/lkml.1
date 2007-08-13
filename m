Return-Path: <linux-kernel-owner+w=401wt.eu-S971279AbXHMJLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971279AbXHMJLe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965790AbXHMGbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:31:42 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1043 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966963AbXHMGbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:31:41 -0400
Date: Sun, 12 Aug 2007 23:30:39 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
       autofs@linux.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [276/2many] MAINTAINERS - KERNEL AUTOMOUNTER (AUTOFS)
Message-ID: <46bffa8f.1p/wvIRMYzk7ZcWd%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index d61676a..dc0823d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2641,6 +2641,7 @@ P:	H. Peter Anvin
 M:	hpa@zytor.com
 L:	autofs@linux.kernel.org
 S:	Odd Fixes
+F:	fs/autofs/
 
 KERNEL AUTOMOUNTER v4 (AUTOFS4)
 P:	Ian Kent
