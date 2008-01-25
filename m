Return-Path: <linux-kernel-owner+w=401wt.eu-S1757254AbYAYHNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbYAYHNu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:13:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbYAYHNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:13:40 -0500
Received: from mail.suse.de ([195.135.220.2]:52350 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965AbYAYHNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:13:40 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Li Yang <leo@zh-kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 001/196] Chinese: Add the known_regression URI to the HOWTO
Date: Thu, 24 Jan 2008 23:08:59 -0800
Message-Id: <1201245134-4876-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Yang <leo@zh-kernel.org>

Update translation for commit be3884943674f8ee7656b1d8b71c087ec900c836.

Signed-off-by: Li Yang <leo@zh-kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/zh_CN/HOWTO |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Documentation/zh_CN/HOWTO b/Documentation/zh_CN/HOWTO
index 48fc67b..c8660da 100644
--- a/Documentation/zh_CN/HOWTO
+++ b/Documentation/zh_CN/HOWTO
@@ -218,6 +218,8 @@ kernel.org网站的pub/linux/kernel/v2.6/目录下找到它。它的开发遵循
     时，一个新的-rc版本就会被发布。计划是每周都发布新的-rc版本。
   - 这个过程一直持续下去直到内核被认为达到足够稳定的状态，持续时间大概是
     6个星期。
+  - 以下地址跟踪了在每个-rc发布中发现的退步列表：
+    http://kernelnewbies.org/known_regressions
 
 关于内核发布，值得一提的是Andrew Morton在linux-kernel邮件列表中如是说：
 	“没有人知道新内核何时会被发布，因为发布是根据已知bug的情况来决定
-- 
1.5.3.8

