Return-Path: <linux-kernel-owner+w=401wt.eu-S1754239AbZJRIMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbZJRIMK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 04:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753862AbZJRILU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 04:11:20 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:50900 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbZJRILS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 04:11:18 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 02/14] dontdiff: add generated
Date: Sun, 18 Oct 2009 10:15:11 +0200
Message-Id: <1255853723-477-2-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <20091018080635.GA13767@merkur.ravnborg.org>
References: <20091018080635.GA13767@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We move more and more stuff to include/generated - so lets ignore the content
for users of plain diff

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Documentation/dontdiff |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Documentation/dontdiff b/Documentation/dontdiff
index e1efc40..5e576a7 100644
--- a/Documentation/dontdiff
+++ b/Documentation/dontdiff
@@ -101,6 +101,7 @@ gconf
 gen-devlist
 gen_crc32table
 gen_init_cpio
+generated
 genksyms
 *_gray256.c
 ihex2fw
-- 
1.6.2.5

