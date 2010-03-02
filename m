Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298Ab0CCACG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 19:02:06 -0500
Received: from kroah.org ([198.145.64.141]:38484 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143Ab0CBX3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:08 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Radu Voicilas <rvoicilas@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 02/62] kset-example: Spelling fixes.
Date: Tue,  2 Mar 2010 15:28:01 -0800
Message-Id: <1267572541-410-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Radu Voicilas <rvoicilas@gmail.com>

No change in functionality.

Signed-off-by: Radu Voicilas <rvoicilas@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 samples/kobject/kset-example.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/samples/kobject/kset-example.c b/samples/kobject/kset-example.c
index 45b7d56..7c60881 100644
--- a/samples/kobject/kset-example.c
+++ b/samples/kobject/kset-example.c
@@ -127,7 +127,7 @@ static struct foo_attribute foo_attribute =
 	__ATTR(foo, 0666, foo_show, foo_store);
 
 /*
- * More complex function where we determine which varible is being accessed by
+ * More complex function where we determine which variable is being accessed by
  * looking at the attribute for the "baz" and "bar" files.
  */
 static ssize_t b_show(struct foo_obj *foo_obj, struct foo_attribute *attr,
@@ -161,7 +161,7 @@ static struct foo_attribute bar_attribute =
 	__ATTR(bar, 0666, b_show, b_store);
 
 /*
- * Create a group of attributes so that we can create and destory them all
+ * Create a group of attributes so that we can create and destroy them all
  * at once.
  */
 static struct attribute *foo_default_attrs[] = {
-- 
1.7.0.1

