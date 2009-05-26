Return-Path: <linux-kernel-owner+w=401wt.eu-S1760272AbZEZXiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760272AbZEZXiF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:38:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758998AbZEZXhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:37:54 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:35336 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758661AbZEZXhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:37:53 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] ignore *.patch files
Date: Tue, 26 May 2009 19:37:54 -0400
Message-Id: <1243381074-10488-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 .gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/.gitignore b/.gitignore
index 51bd99d..3433d7c 100644
--- a/.gitignore
+++ b/.gitignore
@@ -25,6 +25,7 @@
 *.elf
 *.bin
 *.gz
+*.patch
 
 #
 # Top-level generic files
-- 
1.6.3.1

