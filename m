Return-Path: <linux-kernel-owner+w=401wt.eu-S1761271AbYG3Cvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761271AbYG3Cvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 22:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757339AbYG3Cph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 22:45:37 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:46253 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649AbYG3CoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 22:44:19 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, hch@infradead.org, miklos@szeredi.hu,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 12/19] Unionfs: update maintainers
Date: Tue, 29 Jul 2008 22:43:42 -0400
Message-Id: <1217385840848-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12173858291233-git-send-email-ezk@cs.sunysb.edu>
References: <12173858291233-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 MAINTAINERS |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 797e7b9..c722f8e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4176,10 +4176,9 @@ S:	Maintained
 UNIONFS
 P:	Erez Zadok
 M:	ezk@cs.sunysb.edu
-P:	Josef "Jeff" Sipek
-M:	jsipek@cs.sunysb.edu
 L:	unionfs@filesystems.org
 W:	http://unionfs.filesystems.org
+T:	git git.kernel.org/pub/scm/linux/kernel/git/ezk/unionfs.git
 S:	Maintained
 
 USB ACM DRIVER
-- 
1.5.2.2

