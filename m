Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541AbZIWIYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbZIWIYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 04:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754490AbZIWIYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 04:24:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754356AbZIWIYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 04:24:18 -0400
Date: Wed, 23 Sep 2009 04:24:05 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, dri-devel@lists.sourceforge.net,
       Amerigo Wang <amwang@redhat.com>
Message-Id: <20090923082638.4391.22459.sendpatchset@localhost.localdomain>
Subject: [Patch] drm: create gitignore file for radeon
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Got lots of untracked files after compiling.
These files are generated, thus should be ignored by git.

Cc:David Airlie <airlied@linux.ie>
Signed-off-by: WANG Cong <amwang@redhat.com>

---
diff --git a/drivers/gpu/drm/radeon/.gitignore b/drivers/gpu/drm/radeon/.gitignore
new file mode 100644
index 0000000..403eb3a
--- /dev/null
+++ b/drivers/gpu/drm/radeon/.gitignore
@@ -0,0 +1,3 @@
+mkregtable
+*_reg_safe.h
+
