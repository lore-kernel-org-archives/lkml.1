Return-Path: <linux-kernel-owner+w=401wt.eu-S942148AbXHMHf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942148AbXHMHf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966252AbXHMG0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:26:10 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4101 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966149AbXHMG0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:26:05 -0400
Date: Sun, 12 Aug 2007 23:25:15 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, sfrench@samba.org,
       samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
       linux-cifs-client@lists.samba.org, akpm@linux-foundation.org
Subject: [PATCH] [123/2many] MAINTAINERS - COMMON INTERNET FILE SYSTEM
 (CIFS)
Message-ID: <46bff94b.cqAV08ZZtCVJZMCU%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 1c014f1..5144e4e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1201,6 +1201,7 @@ L:	samba-technical@lists.samba.org
 W:	http://us1.samba.org/samba/Linux_CIFS_client.html
 T:	git kernel.org:/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
 S:	Supported
+F:	fs/cifs/
 
 CONFIGFS
 P:	Joel Becker
