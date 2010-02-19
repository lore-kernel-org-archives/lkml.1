Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab0BSMdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 07:33:18 -0500
Received: from nox.protox.org ([88.191.38.29]:37425 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312Ab0BSMdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 07:33:17 -0500
From: Jerome Glisse <jglisse@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH] git ignore *.builtin generated file
Date: Fri, 19 Feb 2010 13:33:10 +0100
Message-Id: <1266582790-11506-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes git ignore any *.builtin file (best patch of the year)

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 .gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/.gitignore b/.gitignore
index 946c7ec..2db1c56 100644
--- a/.gitignore
+++ b/.gitignore
@@ -29,6 +29,7 @@
 *.lzma
 *.patch
 *.gcno
+*.builtin
 
 #
 # Top-level generic files
-- 
1.6.6

