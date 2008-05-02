Return-Path: <linux-kernel-owner+w=401wt.eu-S936976AbYEBUs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936976AbYEBUs7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 16:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936261AbYEBUsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 16:48:45 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:36572 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936026AbYEBUso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 16:48:44 -0400
From: sam@ravnborg.org
To: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Cc: Sam Ravnborg <sam@uranus.ravnborg.org>
Subject: [PATCH] kconfig: .gitignore aconf
Date: Fri,  2 May 2008 22:49:17 +0200
Message-Id: <1209761358-6579-4-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.4.1.143.ge7e51
In-Reply-To: <1209761358-6579-3-git-send-email-sam@ravnborg.org>
References: <20080502204729.GA6534@uranus.ravnborg.org>
 <1209761358-6579-1-git-send-email-sam@ravnborg.org>
 <1209761358-6579-2-git-send-email-sam@ravnborg.org>
 <1209761358-6579-3-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@uranus.ravnborg.org>

---
 scripts/kconfig/.gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/.gitignore b/scripts/kconfig/.gitignore
index b49584c..ae664f9 100644
--- a/scripts/kconfig/.gitignore
+++ b/scripts/kconfig/.gitignore
@@ -13,6 +13,7 @@ lkc_defs.h
 # configuration programs
 #
 conf
+aconf
 mconf
 qconf
 gconf
-- 
1.5.4.1.143.ge7e51

