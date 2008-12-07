Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbYLGSfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbYLGSfp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 13:35:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754506AbYLGSbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 13:31:37 -0500
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:55734 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529AbYLGSbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 13:31:35 -0500
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 13/13] checkpatch: version: 0.26
Date: Sun,  7 Dec 2008 18:30:50 +0000
Message-Id: <1228674650-24392-14-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.4.911.gc990
In-Reply-To: <1228674650-24392-1-git-send-email-apw@shadowen.org>
References: <1228674650-24392-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Whitcroft <apw@canonical.com>

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index bd6ac90..7bed4ed 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -10,7 +10,7 @@ use strict;
 my $P = $0;
 $P =~ s@.*/@@g;
 
-my $V = '0.25';
+my $V = '0.26';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
-- 
1.6.0.4.911.gc990

