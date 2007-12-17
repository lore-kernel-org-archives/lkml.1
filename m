Return-Path: <linux-kernel-owner+w=401wt.eu-S932868AbXLQUAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868AbXLQUAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 15:00:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933972AbXLQTlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:41:46 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3214 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933977AbXLQTlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:41:25 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] kernel/: Spelling fixes
Date: Mon, 17 Dec 2007 11:40:27 -0800
Message-Id: <1197920439-5455-21-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918894.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/posix-timers.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 35b4bbf..36d563f 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -493,7 +493,7 @@ sys_timer_create(const clockid_t which_clock,
 		goto retry;
 	else if (error) {
 		/*
-		 * Wierd looking, but we return EAGAIN if the IDR is
+		 * Weird looking, but we return EAGAIN if the IDR is
 		 * full (proper POSIX return value for this)
 		 */
 		error = -EAGAIN;
-- 
1.5.3.7.949.g2221a6

