Return-Path: <linux-kernel-owner+w=401wt.eu-S1761341AbZDSNm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761341AbZDSNm2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 09:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760442AbZDSNlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 09:41:25 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:53342 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758312AbZDSNlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 09:41:21 -0400
From: Markus Heidelberg <markus.heidelberg@web.de>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       Markus Heidelberg <markus.heidelberg@web.de>
Subject: [PATCH 04/10] gitignore: ignore Kconfig i18n files
Date: Sun, 19 Apr 2009 15:41:21 +0200
Message-Id: <1240148487-27584-5-git-send-email-markus.heidelberg@web.de>
X-Mailer: git-send-email 1.6.3.rc1.24.g467d50
In-Reply-To: <1240148487-27584-1-git-send-email-markus.heidelberg@web.de>
References: <1240148487-27584-1-git-send-email-markus.heidelberg@web.de>
X-Provags-ID: V01U2FsdGVkX18JvVKmsXUdzOlrVt8oWPSQZh3/DXjwbD0FUve9
	P2B6v12eG1/0Z6Xz1YZp7vavHk+PLb8VKPVZnJG1+ys9GjMsUy
	JuF401mtruKQl+UmyYlQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Markus Heidelberg <markus.heidelberg@web.de>
---
 scripts/kconfig/.gitignore |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/.gitignore b/scripts/kconfig/.gitignore
index b49584c..01e185f 100644
--- a/scripts/kconfig/.gitignore
+++ b/scripts/kconfig/.gitignore
@@ -8,6 +8,8 @@ lex.*.c
 zconf.hash.c
 *.moc
 lkc_defs.h
+gconf.glade.h
+*.pot
 
 #
 # configuration programs
-- 
1.6.3.rc1.24.g467d50

