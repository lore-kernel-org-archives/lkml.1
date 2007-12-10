Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbXLJCox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbXLJCox (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 21:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbXLJCmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 21:42:52 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:49650 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbXLJCmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 21:42:42 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: hch@infradead.org, viro@ftp.linux.org.uk, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 02/42] Unionfs: unionfs documentation index
Date: Sun,  9 Dec 2007 21:41:35 -0500
Message-Id: <11972545363650-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11972545353262-git-send-email-ezk@cs.sunysb.edu>
References: <11972545353262-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 Documentation/filesystems/unionfs/00-INDEX |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/filesystems/unionfs/00-INDEX

diff --git a/Documentation/filesystems/unionfs/00-INDEX b/Documentation/filesystems/unionfs/00-INDEX
new file mode 100644
index 0000000..96fdf67
--- /dev/null
+++ b/Documentation/filesystems/unionfs/00-INDEX
@@ -0,0 +1,10 @@
+00-INDEX
+	- this file.
+concepts.txt
+	- A brief introduction of concepts.
+issues.txt
+	- A summary of known issues with unionfs.
+rename.txt
+	- Information regarding rename operations.
+usage.txt
+	- Usage information and examples.
-- 
1.5.2.2

