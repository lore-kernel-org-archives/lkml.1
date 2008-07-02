Return-Path: <linux-kernel-owner+w=401wt.eu-S1763621AbYGBLdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763621AbYGBLdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 07:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754836AbYGBLdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 07:33:00 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2914 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbYGBLc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 07:32:59 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 5/5] checkpatch: version 0.21
Date: Wed,  2 Jul 2008 12:31:18 +0100
Message-Id: <1214998278-11767-6-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.5.6.1.201.g3e7d3
In-Reply-To: <1214998278-11767-1-git-send-email-apw@shadowen.org>
References: <1214998278-11767-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 022ee55..bc67793 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -9,7 +9,7 @@ use strict;
 my $P = $0;
 $P =~ s@.*/@@g;
 
-my $V = '0.20';
+my $V = '0.21';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
-- 
1.5.6.1.201.g3e7d3

