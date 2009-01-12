Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbZALMp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbZALMp0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 07:45:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbZALMpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 07:45:12 -0500
Received: from adelie.canonical.com ([91.189.90.139]:40576 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbZALMpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 07:45:11 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 6/6] checkpatch: version: 0.27
Date: Mon, 12 Jan 2009 12:45:04 +0000
Message-Id: <1231764304-1491-7-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.0.4.911.gc990
In-Reply-To: <1231764304-1491-1-git-send-email-apw@canonical.com>
References: <1231764304-1491-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 447435c..45eb0ae 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -10,7 +10,7 @@ use strict;
 my $P = $0;
 $P =~ s@.*/@@g;
 
-my $V = '0.26';
+my $V = '0.27';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
-- 
1.6.0.4.911.gc990

