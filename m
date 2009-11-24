Return-Path: <linux-kernel-owner+w=401wt.eu-S1753190AbZKXFeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbZKXFeK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 00:34:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbZKXFeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 00:34:09 -0500
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:63829 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751780AbZKXFeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 00:34:08 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH] .gitignore: Add bzip2 compressed files.
Date: Tue, 24 Nov 2009 06:34:03 +0100
Message-Id: <1259040843-15401-1-git-send-email-gwingerde@gmail.com>
X-Mailer: git-send-email 1.6.5.3
X-OriginalArrivalTime: 24 Nov 2009 05:34:13.0638 (UTC) FILETIME=[C1A1D260:01CA6CC7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can have bzip2 compressed images nowadays.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 .gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/.gitignore b/.gitignore
index b93fb7e..946c7ec 100644
--- a/.gitignore
+++ b/.gitignore
@@ -25,6 +25,7 @@
 *.elf
 *.bin
 *.gz
+*.bz2
 *.lzma
 *.patch
 *.gcno
-- 
1.6.5.3

