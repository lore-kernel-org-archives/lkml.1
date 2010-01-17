Return-Path: <linux-kernel-owner+w=401wt.eu-S1754621Ab0AQUcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab0AQUcm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 15:32:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754310Ab0AQUcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 15:32:41 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:43818 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab0AQUck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 15:32:40 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: trivial@kernel.org
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
       linux-doc@vger.kernel.org
Subject: [PATCH] doc: update 00-INDEX for Documentation/laptops/
Date: Sun, 17 Jan 2010 18:30:05 -0200
Message-Id: <1263760205-7065-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 Documentation/laptops/00-INDEX |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/Documentation/laptops/00-INDEX b/Documentation/laptops/00-INDEX
index ee5692b..df4fb52 100644
--- a/Documentation/laptops/00-INDEX
+++ b/Documentation/laptops/00-INDEX
@@ -2,6 +2,10 @@
 	- This file
 acer-wmi.txt
 	- information on the Acer Laptop WMI Extras driver.
+asus-laptop.txt
+	- information on the Asus Laptop Extras driver.
+disk-shock-protection.txt
+	- information on hard disk shock protection.
 laptop-mode.txt
 	- how to conserve battery power using laptop-mode.
 sony-laptop.txt
-- 
1.6.6

