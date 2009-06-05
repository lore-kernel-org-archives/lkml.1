Return-Path: <linux-kernel-owner+w=401wt.eu-S1757903AbZFEXtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903AbZFEXtq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 19:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755712AbZFEXmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 19:42:03 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:36410 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329AbZFEXlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 19:41:11 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: maximilian attems <max@stro.at>, Frans Pop <elendil@planet.nl>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 15/39] kbuild, deb-pkg: bump standards version
Date: Sat,  6 Jun 2009 01:42:33 +0200
Message-Id: <1244245377-17441-15-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.3.rc3.40.g75b44
In-Reply-To: <20090605233720.GA13588@uranus.ravnborg.org>
References: <20090605233720.GA13588@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: maximilian attems <max@stro.at>

Latest Debian policy is 3.8.1.
Even if we are not yet compliant to it strive for the latest.

Signed-off-by: maximilian attems <max@stro.at>
Signed-off-by: Frans Pop <elendil@planet.nl>
Acked-by: Andres Salomon <dilinger@debian.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/package/builddeb |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 9708d26..01c2d13 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -147,7 +147,7 @@ Source: linux-upstream
 Section: admin
 Priority: optional
 Maintainer: $maintainer
-Standards-Version: 3.6.1
+Standards-Version: 3.8.1
 EOF
 
 if [ "$ARCH" = "um" ]; then
-- 
1.6.3.rc3.40.g75b44

