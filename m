Return-Path: <linux-kernel-owner+w=401wt.eu-S1754718AbXLJCnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbXLJCnX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 21:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbXLJCmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 21:42:40 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:49609 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbXLJCmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 21:42:37 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: hch@infradead.org, viro@ftp.linux.org.uk, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 01/42] Unionfs: filesystems documentation index
Date: Sun,  9 Dec 2007 21:41:34 -0500
Message-Id: <11972545362280-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11972545353262-git-send-email-ezk@cs.sunysb.edu>
References: <11972545353262-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 Documentation/filesystems/00-INDEX |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Documentation/filesystems/00-INDEX b/Documentation/filesystems/00-INDEX
index 1de155e..b168331 100644
--- a/Documentation/filesystems/00-INDEX
+++ b/Documentation/filesystems/00-INDEX
@@ -96,6 +96,8 @@ udf.txt
 	- info and mount options for the UDF filesystem.
 ufs.txt
 	- info on the ufs filesystem.
+unionfs/
+	- info on the unionfs filesystem
 vfat.txt
 	- info on using the VFAT filesystem used in Windows NT and Windows 95
 vfs.txt
-- 
1.5.2.2

