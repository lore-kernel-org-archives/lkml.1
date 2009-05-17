Return-Path: <linux-kernel-owner+w=401wt.eu-S1755750AbZEQXiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750AbZEQXiO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 19:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755401AbZEQXgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 19:36:52 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:46383 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853AbZEQXgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 19:36:48 -0400
From: Markus Heidelberg <markus.heidelberg@web.de>
To: Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       Markus Heidelberg <markus.heidelberg@web.de>
Subject: [PATCH resend 04/10] gitignore: ignore Kconfig i18n files
Date: Mon, 18 May 2009 01:36:48 +0200
Message-Id: <1242603414-9267-5-git-send-email-markus.heidelberg@web.de>
X-Mailer: git-send-email 1.6.3.1.20.ga30f
In-Reply-To: <1242603414-9267-1-git-send-email-markus.heidelberg@web.de>
References: <1242603414-9267-1-git-send-email-markus.heidelberg@web.de>
X-Provags-ID: V01U2FsdGVkX1/6aUN9FVG0l/9lxQZ5NNRqx2tuTtTcnK438b+C
	WMBH48m1KZjrDUdHjG31G/ytqSKaUW31oa9ubVwAuIiT7Qa5v/
	9k4IzipBKCa2hu9UJqZA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Markus Heidelberg <markus.heidelberg@web.de>
---
 scripts/kconfig/.gitignore |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/.gitignore b/scripts/kconfig/.gitignore
index b49584c..6a36a76 100644
--- a/scripts/kconfig/.gitignore
+++ b/scripts/kconfig/.gitignore
@@ -8,6 +8,9 @@ lex.*.c
 zconf.hash.c
 *.moc
 lkc_defs.h
+gconf.glade.h
+*.pot
+*.mo
 
 #
 # configuration programs
-- 
1.6.3.1.20.ga30f

