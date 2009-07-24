Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbZGXS3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbZGXS3s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 14:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753797AbZGXS3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 14:29:47 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:32832 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766AbZGXS3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 14:29:47 -0400
Subject: [PATCH] kbuild: remove extraneous blank line after declaration of
 usage()
From: Trevor Keith <tsrk@tsrk.net>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, trivial@kernel.org
Content-Type: text/plain
Date: Fri, 24 Jul 2009 11:29:29 -0700
Message-Id: <1248460169.16421.2.camel@tsrk-ibm>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Trevor Keith <tsrk@tsrk.net>
---
 scripts/basic/fixdep.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/scripts/basic/fixdep.c b/scripts/basic/fixdep.c
index d7c1b04..27d0924 100644
--- a/scripts/basic/fixdep.c
+++ b/scripts/basic/fixdep.c
@@ -126,7 +126,6 @@ char *depfile;
 char *cmdline;
 
 static void usage(void)
-
 {
 	fprintf(stderr, "Usage: fixdep <depfile> <target> <cmdline>\n");
 	exit(1);
-- 
1.6.0.4


