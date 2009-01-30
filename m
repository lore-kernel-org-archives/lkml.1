Return-Path: <linux-kernel-owner+w=401wt.eu-S1756878AbZA3PIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbZA3PIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 10:08:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753853AbZA3PFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 10:05:37 -0500
Received: from adelie.canonical.com ([91.189.90.139]:60187 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbZA3PFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 10:05:35 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 8/8] checkpatch: version 0.28
Date: Fri, 30 Jan 2009 15:05:20 +0000
Message-Id: <1233327920-16691-9-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.1.2.419.g0d87e
In-Reply-To: <1233327920-16691-1-git-send-email-apw@canonical.com>
References: <1233327920-16691-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 60ad8db..2d5ece7 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -10,7 +10,7 @@ use strict;
 my $P = $0;
 $P =~ s@.*/@@g;
 
-my $V = '0.27';
+my $V = '0.28';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
-- 
1.6.1.2.419.g0d87e

