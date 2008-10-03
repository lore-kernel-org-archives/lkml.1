Return-Path: <linux-kernel-owner+w=401wt.eu-S1755043AbYJCPvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043AbYJCPvy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 11:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009AbYJCPup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 11:50:45 -0400
Received: from tallyho.bytemark.co.uk ([80.68.81.166]:58079 "EHLO
	tallyho.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962AbYJCPun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 11:50:43 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 13/13] checkpatch: version: 0.24
Date: Fri,  3 Oct 2008 16:25:54 +0100
Message-Id: <1223047554-31111-14-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.1.451.gc8d31
In-Reply-To: <1223047554-31111-1-git-send-email-apw@shadowen.org>
References: <1223047554-31111-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index ada27c4..e30bac1 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -9,7 +9,7 @@ use strict;
 my $P = $0;
 $P =~ s@.*/@@g;
 
-my $V = '0.23';
+my $V = '0.24';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
-- 
1.6.0.1.451.gc8d31

