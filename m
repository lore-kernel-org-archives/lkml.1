Return-Path: <linux-kernel-owner+w=401wt.eu-S1752075AbZLCF2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbZLCF2j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 00:28:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbZLCF2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 00:28:37 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:56845 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbZLCF2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 00:28:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=gQXuJH84L6LkTmqQJmZrFKw2CgZ1DR7taccFodkhM/YZeElRKcfJttDKBR4CYE0Prd
         e+dNn3rU4U9xSmVgTOrqwuYHUYDjYFHRQlmG85+GkmpOZs7CTAFnQaIt1mlQD6g6KnW4
         /41LsWWQNDrYbT5H8i1RzTrAx4Qz+80csjKlo=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH] Fix a typo in slub.txt. Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
Date: Wed,  2 Dec 2009 21:27:57 -0800
Message-Id: <1259818077-10977-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.GIT
In-Reply-To: <1259818077-10977-1-git-send-email-justinmattock@gmail.com>
References: <1259818077-10977-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Justin P. Mattock <justinmattock@gmail.com>

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

