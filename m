Return-Path: <linux-kernel-owner+w=401wt.eu-S1755884AbZFEXpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbZFEXpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 19:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755880AbZFEXll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 19:41:41 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:36439 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647AbZFEXlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 19:41:14 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Mike Frysinger <vapier@gentoo.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 38/39] ignore *.patch files
Date: Sat,  6 Jun 2009 01:42:56 +0200
Message-Id: <1244245377-17441-38-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.3.rc3.40.g75b44
In-Reply-To: <20090605233720.GA13588@uranus.ravnborg.org>
References: <20090605233720.GA13588@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
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
1.6.3.rc3.40.g75b44

