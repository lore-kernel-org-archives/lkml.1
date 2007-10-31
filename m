Return-Path: <linux-kernel-owner+w=401wt.eu-S1756660AbXJaFNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660AbXJaFNg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 01:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756465AbXJaFMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 01:12:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:34775 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756425AbXJaFMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 01:12:35 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Keiichi Kii <k-keiichi@bx.jp.nec.com>, Andy Whitcroft <apw@shadowen.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 5/6] fix typo in SubmittingPatches
Date: Tue, 30 Oct 2007 22:11:44 -0700
Message-Id: <1193807505-3821-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1193807505-3821-4-git-send-email-gregkh@suse.de>
References: <20071031050954.GA3791@kroah.com>
 <1193807505-3821-1-git-send-email-gregkh@suse.de>
 <1193807505-3821-2-git-send-email-gregkh@suse.de>
 <1193807505-3821-3-git-send-email-gregkh@suse.de>
 <1193807505-3821-4-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keiichi Kii <k-keiichi@bx.jp.nec.com>

Fix typo.

Signed-off-by: Keiichi Kii <k-keiichi@bx.jp.nec.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/SubmittingPatches |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index a30dd44..681e2b3 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -464,8 +464,8 @@ section Linus Computer Science 101.
 Nuff said.  If your code deviates too much from this, it is likely
 to be rejected without further review, and without comment.
 
-Once significant exception is when moving code from one file to
-another in this case you should not modify the moved code at all in
+One significant exception is when moving code from one file to
+another -- in this case you should not modify the moved code at all in
 the same patch which moves it.  This clearly delineates the act of
 moving the code and your changes.  This greatly aids review of the
 actual differences and allows tools to better track the history of
-- 
1.5.3.4

