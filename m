Return-Path: <linux-kernel-owner+w=401wt.eu-S1755920AbZJZTWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbZJZTWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755303AbZJZTWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:22:38 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:34690 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbZJZTWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:22:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:date:user-agent:cc:mime-version:message-id:subject
         :content-type:content-transfer-encoding;
        b=MTAtJBkNVewP1u2/sfI8YK3LRjF8LRKqnEzODE0QCzUCQkpHT1RtGeJ3hD4o58Kh3n
         cqhgdIjhbcQ/QmNiOmbAcw00Kr8FObSDMzKR7euIUJStfkQl1F6q9WAvNv9n5z/2Ha6v
         IoEmeO7UkK5wX08jBtUiGJmHPAieWPTj0WD8s=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 26 Oct 2009 20:14:33 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: users@host1.serialmonkey.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200910262014.34035.bzolnier@gmail.com>
Subject: [PATCH] MAINTAINERS: rt2x00 list is moderated
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] MAINTAINERS: rt2x00 list is moderated

Cc: users@rt2x00.serialmonkey.com
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/MAINTAINERS
===================================================================
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4325,7 +4325,7 @@ F:	drivers/video/aty/aty128fb.c
 RALINK RT2X00 WIRELESS LAN DRIVER
 P:	rt2x00 project
 L:	linux-wireless@vger.kernel.org
-L:	users@rt2x00.serialmonkey.com
+L:	users@rt2x00.serialmonkey.com (moderated for non-subscribers)
 W:	http://rt2x00.serialmonkey.com/
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git
