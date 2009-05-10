Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870AbZEJFcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbZEJFcm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 01:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbZEJFcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 01:32:33 -0400
Received: from everest.las.ic.unicamp.br ([143.106.60.118]:60526 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbZEJFcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 01:32:33 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: gustavo@padovan.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Add .gitignore for bluez-hcidump
Date: Sun, 10 May 2009 02:29:33 -0300
Message-Id: <1241933373-24083-2-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241933373-24083-1-git-send-email-gustavo@las.ic.unicamp.br>
References: <1241933373-24083-1-git-send-email-gustavo@las.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this file avoids dirty things on git status
---
 .gitignore |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)
 create mode 100644 .gitignore

diff --git a/.gitignore b/.gitignore
new file mode 100644
index 0000000..76bcb61
--- /dev/null
+++ b/.gitignore
@@ -0,0 +1,28 @@
+*.o
+*.a
+*.lo
+*.la
+*.so
+.deps
+.libs
+Makefile
+Makefile.in
+aclocal.m4
+config.guess
+config.h
+config.h.in
+config.log
+config.status
+config.sub
+configure
+depcomp
+install-sh
+libtool
+ltmain.sh
+missing
+stamp-h1
+autom4te.cache
+
+src/bpasniff
+src/csrsniff
+src/hcidump
-- 
1.6.0.6

