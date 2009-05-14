Return-Path: <linux-kernel-owner+w=401wt.eu-S1755235AbZENUoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbZENUoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 16:44:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbZENUn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 16:43:56 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:42411 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbZENUn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 16:43:56 -0400
Subject: [PATCH] TRIVIAL: fix grammo in bus_for_each_dev() kerneldoc
To: jkosina@suse.cz
From: Alex Chiang <achiang@hp.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Date: Thu, 14 May 2009 08:43:53 -0600
Message-ID: <20090514144339.18912.65431.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/base/bus.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index dc030f1..4476a4e 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -279,7 +279,7 @@ static struct device *next_device(struct klist_iter *i)
  *
  * NOTE: The device that returns a non-zero value is not retained
  * in any way, nor is its refcount incremented. If the caller needs
- * to retain this data, it should do, and increment the reference
+ * to retain this data, it should do so, and increment the reference
  * count in the supplied callback.
  */
 int bus_for_each_dev(struct bus_type *bus, struct device *start,

