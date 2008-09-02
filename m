Return-Path: <linux-kernel-owner+w=401wt.eu-S1754696AbYIBR0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbYIBR0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 13:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbYIBRZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 13:25:23 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:36140 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbYIBRZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 13:25:18 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 7/7] checkpatch: version: 0.23
Date: Tue,  2 Sep 2008 18:25:14 +0100
Message-Id: <1220376314-15180-8-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.rc1.258.g80295
In-Reply-To: <1220376314-15180-1-git-send-email-apw@shadowen.org>
References: <1220376314-15180-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index fe4553c..118fe1f 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -9,7 +9,7 @@ use strict;
 my $P = $0;
 $P =~ s@.*/@@g;
 
-my $V = '0.22';
+my $V = '0.23';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
-- 
1.6.0.rc1.258.g80295

