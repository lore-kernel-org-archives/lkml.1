Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbYAYHOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbYAYHOJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:14:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756844AbYAYHNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:13:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47412 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756713AbYAYHNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:13:43 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Li Yang <leo@zh-kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 002/196] Chinese: rephrase English introduction in HOWTO
Date: Thu, 24 Jan 2008 23:09:00 -0800
Message-Id: <1201245134-4876-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Yang <leo@zh-kernel.org>

Rephrase the introduction as suggested by Jesper Juhl.

Signed-off-by: Li Yang <leo@zh-kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/zh_CN/HOWTO |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/zh_CN/HOWTO b/Documentation/zh_CN/HOWTO
index c8660da..79d1c3c 100644
--- a/Documentation/zh_CN/HOWTO
+++ b/Documentation/zh_CN/HOWTO
@@ -1,10 +1,10 @@
 ﻿Chinese translated version of Documentation/HOWTO
 
 If you have any comment or update to the content, please contact the
-original document maintainer directly.  However, if you have problem
+original document maintainer directly.  However, if you have a problem
 communicating in English you can also ask the Chinese maintainer for
-help.  Contact the Chinese maintainer, if this translation is outdated
-or there is problem with translation.
+help.  Contact the Chinese maintainer if this translation is outdated
+or if there is a problem with the translation.
 
 Maintainer: Greg Kroah-Hartman <greg@kroah.com>
 Chinese maintainer: Li Yang <leoli@freescale.com>
-- 
1.5.3.8

