Return-Path: <linux-kernel-owner+w=401wt.eu-S1761325AbZALWxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761325AbZALWxO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:53:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758754AbZALWgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:36:17 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44969 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758244AbZALWgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:36:16 -0500
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@strlen.de>,
       trivial@kernel.org
Date: Mon, 12 Jan 2009 23:35:50 +0100
Message-Id: <1231799750-21060-5-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <alpine.LNX.1.10.0901122314361.5377@jikos.suse.cz>
References: <alpine.LNX.1.10.0901122314361.5377@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ukl@pengutronix.de
Subject: [PATCH] fix typo "resgister" -> "register"
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Kleine-König <ukleinek@strlen.de>

Signed-off-by: Uwe Kleine-König <ukleinek@strlen.de>
Cc: trivial@kernel.org
---
 kernel/trace/ftrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 2f32969..24f4db5 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1902,7 +1902,7 @@ int register_ftrace_function(struct ftrace_ops *ops)
 }
 
 /**
- * unregister_ftrace_function - unresgister a function for profiling.
+ * unregister_ftrace_function - unregister a function for profiling.
  * @ops - ops structure that holds the function to unregister
  *
  * Unregister a function that was added to be called by ftrace profiling.
-- 
1.5.6.5

