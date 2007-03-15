Return-Path: <linux-kernel-owner+w=401wt.eu-S1161348AbXCON7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161348AbXCON7D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 09:59:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161349AbXCON7B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 09:59:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161348AbXCON7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 09:59:00 -0400
Date: Thu, 15 Mar 2007 09:58:59 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       akpm@linux-foundation.org, tony.luck@intel.com
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20070315135859.11556.89556.sendpatchset@prarit.boston.redhat.com>
Subject: [PATCH]: Add gate.lds to Documentation/dontdiff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add gate.lds to dontdiff for ia64.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/Documentation/dontdiff b/Documentation/dontdiff
index 63c2d0c..0bf10c7 100644
--- a/Documentation/dontdiff
+++ b/Documentation/dontdiff
@@ -86,6 +86,7 @@ filelist
 fixdep
 fore200e_mkfirm
 fore200e_pca_fw.c*
+gate.lds
 gen-devlist
 gen-kdb_cmds.c*
 gen_crc32table
