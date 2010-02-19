Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab0BSLo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 06:44:29 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:54792 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab0BSLo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 06:44:27 -0500
From: Thomas Weber <weber@corscience.de>
To: trivial@kernel.org
Cc: Thomas Weber <weber@corscience.de>, Roman Zippel <zippel@linux-m68k.org>,
       Markus Heidelberg <markus.heidelberg@web.de>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Trivial: Scripts: kconfig: util: Fix typo in comment
Date: Fri, 19 Feb 2010 12:43:44 +0100
Message-Id: <1266579824-14706-1-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.6.4.4
X-Provags-ID: V01U2FsdGVkX18NE9GitKCCcpHQ7c9rr4QKizsUlyF1xi6j4Oa
 nWP2pnEHAQX4jpm1LrWWeqA9IRWXtx9Tt1IDr8KYzmmuL0bmci
 Ptbijjl7lw3rsecC3iosg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sting replaced with string

Signed-off-by: Thomas Weber <weber@corscience.de>
---
 scripts/kconfig/util.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/util.c b/scripts/kconfig/util.c
index b6b2a46..25d1ec4 100644
--- a/scripts/kconfig/util.c
+++ b/scripts/kconfig/util.c
@@ -72,7 +72,7 @@ int file_write_dep(const char *name)
 }
 
 
-/* Allocate initial growable sting */
+/* Allocate initial growable string */
 struct gstr str_new(void)
 {
 	struct gstr gs;
-- 
1.6.4.4

