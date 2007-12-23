Return-Path: <linux-kernel-owner+w=401wt.eu-S1755920AbXLWH2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbXLWH2W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 02:28:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbXLWH2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 02:28:15 -0500
Received: from ns1.suse.de ([195.135.220.2]:48413 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbXLWH2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 02:28:15 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?utf-8?q?Hans-J=C3=BCrgen=20Koch?= <hjk@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/2] UIO: Add a MAINTAINERS entry for Userspace I/O
Date: Sat, 22 Dec 2007 23:27:15 -0800
Message-Id: <1198394836-8994-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <20071223072424.GB8764@kroah.com>
References: <20071223072424.GB8764@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans-Jürgen Koch <hjk@linutronix.de>

This patch adds an entry for the Userspace I/O framework to MAINTAINERS.

Signed-off-by: Hans J. Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 MAINTAINERS |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3c7db62..a06ee43 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4054,6 +4054,14 @@ L:	user-mode-linux-user@lists.sourceforge.net
 W:	http://user-mode-linux.sourceforge.net
 S:	Maintained
 
+USERSPACE I/O (UIO)
+P:	Hans J. Koch
+M:	hjk@linutronix.de
+P:	Greg Kroah-Hartman
+M:	gregkh@suse.de
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+
 FAT/VFAT/MSDOS FILESYSTEM:
 P:	OGAWA Hirofumi
 M:	hirofumi@mail.parknet.co.jp
-- 
1.5.3.7

