Return-Path: <linux-kernel-owner+w=401wt.eu-S964951AbZGQR1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964951AbZGQR1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 13:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964919AbZGQR1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 13:27:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49180 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964916AbZGQR1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 13:27:44 -0400
From: Izik Eidus <ieidus@redhat.com>
To: akpm@linux-foundation.org
Cc: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, chrisw@redhat.com,
       avi@redhat.com, riel@redhat.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, nickpiggin@yahoo.com.au, ieidus@redhat.com
Subject: [PATCH 09/10] ksm: change copyright message
Date: Fri, 17 Jul 2009 20:30:49 +0300
Message-Id: <1247851850-4298-10-git-send-email-ieidus@redhat.com>
In-Reply-To: <1247851850-4298-9-git-send-email-ieidus@redhat.com>
References: <1247851850-4298-1-git-send-email-ieidus@redhat.com>
 <1247851850-4298-2-git-send-email-ieidus@redhat.com>
 <1247851850-4298-3-git-send-email-ieidus@redhat.com>
 <1247851850-4298-4-git-send-email-ieidus@redhat.com>
 <1247851850-4298-5-git-send-email-ieidus@redhat.com>
 <1247851850-4298-6-git-send-email-ieidus@redhat.com>
 <1247851850-4298-7-git-send-email-ieidus@redhat.com>
 <1247851850-4298-8-git-send-email-ieidus@redhat.com>
 <1247851850-4298-9-git-send-email-ieidus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Izik Eidus <ieidus@redhat.com>

Adding Hugh Dickins into the authors list.

Signed-off-by: Izik Eidus <ieidus@redhat.com>
---
 mm/ksm.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index a0fbdb2..75d7802 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -4,11 +4,12 @@
  * This code enables dynamic sharing of identical pages found in different
  * memory areas, even if they are not shared by fork()
  *
- * Copyright (C) 2008 Red Hat, Inc.
+ * Copyright (C) 2008-2009 Red Hat, Inc.
  * Authors:
  *	Izik Eidus
  *	Andrea Arcangeli
  *	Chris Wright
+ *	Hugh Dickins
  *
  * This work is licensed under the terms of the GNU GPL, version 2.
  */
-- 
1.5.6.5

