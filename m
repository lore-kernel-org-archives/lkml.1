Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbXGRFJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbXGRFJr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 01:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbXGRFJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 01:09:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:54390 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbXGRFJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 01:09:38 -0400
Date: Tue, 17 Jul 2007 22:09:34 -0700
From: Brandon Philips <bphilips@suse.de>
To: Greg KH <gregkh@suse.de>, Tejun Heo <teheo@suse.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation fix devres.txt: lib/iomap.c -> lib/devres.c
Message-ID: <20070718050934.GA4397@ifup.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Brandon Philips <bphilips@suse.de>
---
 Documentation/driver-model/devres.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index 6c8d8f2..8569072 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -207,7 +207,7 @@ responsibility.  This is usually non-issue because bus ops and
 resource allocations already do the job.
 
 For an example of single-instance devres type, read pcim_iomap_table()
-in lib/iomap.c.
+in lib/devres.c.
 
 All devres interface functions can be called without context if the
 right gfp mask is given.
-- 
1.5.3.GIT

