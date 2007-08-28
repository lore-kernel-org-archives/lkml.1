Return-Path: <linux-kernel-owner+w=401wt.eu-S1751576AbXH1GiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576AbXH1GiD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 02:38:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754689AbXH1Ghv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 02:37:51 -0400
Received: from qb-out-0506.google.com ([72.14.204.226]:55639 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658AbXH1Ghu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 02:37:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mTE7ygRQ1BkTdwZ4g0EGP9x+QOphVLn7T/IxFTKSkSIW0WpNcxoIGJzbkTyf4cjLBVO3ksS6AN7S+w+9f6ffI1CX/tb/WyX+TabmaMn7izKE7WwzfUY2T/p2qTnBqFeTmtSc8r028l5LgS6BzKaq8J9elT8WowQ0grtRpznv0Vg=
From: Denis Cheng <crquan@gmail.com>
To: Linus Torvalds <torvalds@osdl.org>, "Theodore Ts'o" <tytso@mit.edu>,
       Wyatt Banks <wyatt@banksresearch.com>,
       David Teigland <teigland@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-kernel@vger.kernel.org, cr_quan@163.com
Subject: [PATCH 2/2] Documentation: add entries to filesystems/00-INDEX for several untracked files
Date: Tue, 28 Aug 2007 14:38:02 +0800
Message-Id: <11882830991813-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.rc5
In-Reply-To: <11882830821504-git-send-email-crquan@gmail.com>
References: <11882830821504-git-send-email-crquan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 Documentation/filesystems/00-INDEX |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/Documentation/filesystems/00-INDEX b/Documentation/filesystems/00-INDEX
index 5717858..9e2341e 100644
--- a/Documentation/filesystems/00-INDEX
+++ b/Documentation/filesystems/00-INDEX
@@ -32,6 +32,8 @@ directory-locking
 	- info about the locking scheme used for directory operations.
 dlmfs.txt
 	- info on the userspace interface to the OCFS2 DLM.
+ecryptfs.txt
+	- info on the eCryptfs file system.
 ext2.txt
 	- info, mount options and specifications for the Ext2 filesystem.
 ext3.txt
@@ -42,10 +44,16 @@ files.txt
 	- info on file management in the Linux kernel.
 fuse.txt
 	- info on the Filesystem in User SpacE including mount options.
+gfs2.txt
+	- info on the Global File System 2.
 hfs.txt
 	- info on the Macintosh HFS Filesystem for Linux.
+hfsplus.txt
+	- info on the Macintosh HFSPlus Filesystem for Linux.
 hpfs.txt
 	- info and mount options for the OS/2 HPFS.
+inotify.txt
+	- info on the powerful yet simple file change notification system.
 isofs.txt
 	- info and mount options for the ISO 9660 (CDROM) filesystem.
 jfs.txt
-- 
1.5.3.rc5

