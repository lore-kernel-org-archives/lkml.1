Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316Ab0BBTJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 14:09:22 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:12279 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241Ab0BBTJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 14:09:12 -0500
Subject: [PATCH v2 17/18] IB/ucm: clean whitespace errors
To: rdreier@cisco.com
From: Alex Chiang <achiang@hp.com>
Cc: linux-rdma@vger.kernel.org, justin.chen@hp.com,
       linux-kernel@vger.kernel.org
Date: Tue, 02 Feb 2010 12:09:11 -0700
Message-ID: <20100202190911.28217.23795.stgit@bob.kio>
In-Reply-To: <20100202185235.28217.64521.stgit@bob.kio>
References: <20100202185235.28217.64521.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As shown when 'let c_space_errors=1' is set in vim.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/infiniband/core/ucm.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index 1203ca4..7bf0a82 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -1223,10 +1223,10 @@ static void ib_ucm_release_dev(struct device *dev)
 }
 
 static const struct file_operations ucm_fops = {
-	.owner 	 = THIS_MODULE,
-	.open 	 = ib_ucm_open,
+	.owner	 = THIS_MODULE,
+	.open	 = ib_ucm_open,
 	.release = ib_ucm_close,
-	.write 	 = ib_ucm_write,
+	.write	 = ib_ucm_write,
 	.poll    = ib_ucm_poll,
 };
 

