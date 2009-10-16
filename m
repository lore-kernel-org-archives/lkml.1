Return-Path: <linux-kernel-owner+w=401wt.eu-S932242AbZJPSkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242AbZJPSkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 14:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754393AbZJPSkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 14:40:09 -0400
Received: from adelie.canonical.com ([91.189.90.139]:53174 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288AbZJPSkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 14:40:08 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 7/7] checkpatch: version 0.30
Date: Fri, 16 Oct 2009 19:39:32 +0100
Message-Id: <1255718372-22805-8-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1255718372-22805-1-git-send-email-apw@canonical.com>
References: <1255718372-22805-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 07678c1..9f5c1b7 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -10,7 +10,7 @@ use strict;
 my $P = $0;
 $P =~ s@.*/@@g;
 
-my $V = '0.29';
+my $V = '0.30';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
-- 
1.6.3.3

