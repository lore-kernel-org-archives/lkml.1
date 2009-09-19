Return-Path: <linux-kernel-owner+w=401wt.eu-S1753735AbZISVkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbZISVkQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:40:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbZISVkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:40:11 -0400
Received: from kroah.org ([198.145.64.141]:50987 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481AbZISVkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:40:08 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 25/79] tty: Fix a typo noted in passing
Date: Sat, 19 Sep 2009 14:36:30 -0700
Message-Id: <1253396244-7885-25-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/tty_io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index a3afa0c..9384480 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -2085,7 +2085,7 @@ static int tioccons(struct file *file)
  *	the generic functionality existed. This piece of history is preserved
  *	in the expected tty API of posix OS's.
  *
- *	Locking: none, the open fle handle ensures it won't go away.
+ *	Locking: none, the open file handle ensures it won't go away.
  */
 
 static int fionbio(struct file *file, int __user *p)
-- 
1.6.4.2

