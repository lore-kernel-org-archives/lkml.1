Return-Path: <linux-kernel-owner+w=401wt.eu-S1754324AbXH1Ghp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbXH1Ghp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 02:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbXH1Ghi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 02:37:38 -0400
Received: from hu-out-0506.google.com ([72.14.214.225]:15224 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbXH1Ghh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 02:37:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id:x-mailer;
        b=W6Ta3LMfq2Sj/JlptF95bUr7p4yNwNpjUdMN4dlIS5DTEGYGlyoRbw0/K/JzlPD9gEa8IGUD7vNWlqFpNmuxHW9xW+WPGwOechY3+p20lqyeuXZHX+9ZUc3aYwU8Ik1EuTNf766gDpXz52RJ0pNOpYsXMQEyS8CBX5LRKLNS5vI=
From: Denis Cheng <crquan@gmail.com>
To: Linus Torvalds <torvalds@osdl.org>, "Theodore Ts'o" <tytso@mit.edu>,
       Wyatt Banks <wyatt@banksresearch.com>,
       David Teigland <teigland@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-kernel@vger.kernel.org, cr_quan@163.com
Subject: [PATCH 1/2] Documentation: fix type error
Date: Tue, 28 Aug 2007 14:38:01 +0800
Message-Id: <11882830821504-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.rc5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 .../filesystems/ramfs-rootfs-initramfs.txt         |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/filesystems/ramfs-rootfs-initramfs.txt b/Documentation/filesystems/ramfs-rootfs-initramfs.txt
index 25981e2..bdd60a4 100644
--- a/Documentation/filesystems/ramfs-rootfs-initramfs.txt
+++ b/Documentation/filesystems/ramfs-rootfs-initramfs.txt
@@ -118,7 +118,7 @@ All this differs from the old initrd in several ways:
     with the new root (cd /newmount; mount --move . /; chroot .), attach
     stdin/stdout/stderr to the new /dev/console, and exec the new init.
 
-    Since this is a remarkably persnickity process (and involves deleting
+    Since this is a remarkably persnickety process (and involves deleting
     commands before you can run them), the klibc package introduced a helper
     program (utils/run_init.c) to do all this for you.  Most other packages
     (such as busybox) have named this command "switch_root".
-- 
1.5.3.rc5

