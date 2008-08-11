Return-Path: <linux-kernel-owner+w=401wt.eu-S1759007AbYHKUUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759007AbYHKUUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 16:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758149AbYHKUSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 16:18:38 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:41291 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758141AbYHKUSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 16:18:37 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 17/17] checkpatch: version: 0.22
Date: Mon, 11 Aug 2008 21:13:12 +0100
Message-Id: <1218485592-6679-18-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.rc1.258.g80295
In-Reply-To: <1218485592-6679-1-git-send-email-apw@shadowen.org>
References: <1218485592-6679-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index ba677c1..66bcedc 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -9,7 +9,7 @@ use strict;
 my $P = $0;
 $P =~ s@.*/@@g;
 
-my $V = '0.21';
+my $V = '0.22';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
-- 
1.6.0.rc1.258.g80295

