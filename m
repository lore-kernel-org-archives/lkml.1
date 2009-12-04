Return-Path: <linux-kernel-owner+w=401wt.eu-S1755152AbZLDIhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbZLDIhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 03:37:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755081AbZLDIhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 03:37:40 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:56140 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077AbZLDIhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 03:37:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sdoz02BOpqEglNsanHKFrKXTjU+5rlyAzVpaKmWYokRRdqhjxmf0b7HIoJkNFS2471
         s0mnYW6pVckImp9r48VMVlda/qUXZbsuDELcWaAmHVwo3VRCgxGK3kypi4L65wzU6yPw
         Q+axzQfiXi7b+L/3rh/GIydJeumME0M/8au6Y=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH] Fix a typo in slub.txt.
Date: Fri,  4 Dec 2009 00:36:35 -0800
Message-Id: <1259915795-2305-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.GIT
In-Reply-To: <1259915795-2305-1-git-send-email-justinmattock@gmail.com>
References: <1259915795-2305-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
---
 Documentation/vm/slub.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/vm/slub.txt b/Documentation/vm/slub.txt
index 510917f..b37300e 100644
--- a/Documentation/vm/slub.txt
+++ b/Documentation/vm/slub.txt
@@ -245,7 +245,7 @@ been overwritten. Here a string of 8 characters was written into a slab that
 has the length of 8 characters. However, a 8 character string needs a
 terminating 0. That zero has overwritten the first byte of the Redzone field.
 After reporting the details of the issue encountered the FIX SLUB message
-tell us that SLUB has restored the Redzone to its proper value and then
+tells us that SLUB has restored the Redzone to its proper value and then
 system operations continue.
 
 Emergency operations:
-- 
1.6.5.GIT

