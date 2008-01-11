Return-Path: <linux-kernel-owner+w=401wt.eu-S1762687AbYAKVuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762687AbYAKVuc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 16:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761374AbYAKVuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 16:50:20 -0500
Received: from mail.fieldses.org ([66.93.2.214]:55617 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759328AbYAKVuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 16:50:18 -0500
From: "J. Bruce Fields" <bfields@citi.umich.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [PATCH] REPORTING-BUGS: cc the mailing list too
Date: Fri, 11 Jan 2008 16:50:16 -0500
Message-Id: <1200088216-9211-5-git-send-email-bfields@citi.umich.edu>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1200088216-9211-4-git-send-email-bfields@citi.umich.edu>
References: <1200088216-9211-1-git-send-email-bfields@citi.umich.edu>
 <1200088216-9211-2-git-send-email-bfields@citi.umich.edu>
 <1200088216-9211-3-git-send-email-bfields@citi.umich.edu>
 <1200088216-9211-4-git-send-email-bfields@citi.umich.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

People should also cc relevant mailing lists when reporting bugs.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
---
 REPORTING-BUGS |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/REPORTING-BUGS b/REPORTING-BUGS
index ac02e42..ab0c566 100644
--- a/REPORTING-BUGS
+++ b/REPORTING-BUGS
@@ -10,11 +10,12 @@ bug report. This explains what you should do with the "Oops" information
 to make it useful to the recipient.
 
       Send the output to the maintainer of the kernel area that seems to
-be involved with the problem. Don't worry too much about getting the
-wrong person. If you are unsure send it to the person responsible for the
-code relevant to what you were doing. If it occurs repeatably try and
-describe how to recreate it. That is worth even more than the oops itself.
-The list of maintainers is in the MAINTAINERS file in this directory.
+be involved with the problem, and cc the relevant mailing list. Don't
+worry too much about getting the wrong person. If you are unsure send it
+to the person responsible for the code relevant to what you were doing.
+If it occurs repeatably try and describe how to recreate it. That is
+worth even more than the oops itself.  The list of maintainers and
+mailing lists is in the MAINTAINERS file in this directory.
 
       If it is a security bug, please copy the Security Contact listed
 in the MAINTAINERS file.  They can help coordinate bugfix and disclosure.
-- 
1.5.4.rc2.60.gb2e62

