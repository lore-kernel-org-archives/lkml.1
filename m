Return-Path: <linux-kernel-owner+w=401wt.eu-S945290AbXHMMem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S945290AbXHMMem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757776AbXHMHAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 03:00:16 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:26934 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbXHMHAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 03:00:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:references:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:x-mimeole:in-reply-to:thread-index;
        b=iTI0F8pAfhcaHiW0QmmKKnbgRM5yPACR0+JUInkls5Zo0kllljRY3teTg/1h7S252kLwg0iXJfMF8kmUIfpajJ6wRPKLkI+0eh3wcBL9PLiuRlKQVh/k/WEJYDo07Kp+/7O6gy60CBAbhVibDUCzfjscxjN6u56Fo8mBJd+rPg8=
From: "Edison Wong" <hswong3i@gmail.com>
To: <joe@perches.com>, <torvalds@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <hlhung3i@gmail.com>,
       <akpm@linux-foundation.org>
References: <46bffc0f.E8NW2ppJgFoVM7kH%joe@perches.com>
Subject: RE: [PATCH] [470/2many] MAINTAINERS - TCP LOW PRIORITY MODULE
Date: Mon, 13 Aug 2007 14:59:57 +0800
Message-ID: <000f01c7dd77$91c67e60$6783a8c0@LENOVOBF3ABCC9>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
In-Reply-To: <46bffc0f.E8NW2ppJgFoVM7kH%joe@perches.com>
Thread-Index: AcfddGTGGs+nv7eaQ9K4LrrPNJLQWQAAo/+Q
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry that since Mike and I are both Chinese, the naming format is a bit different from English style

Hung Hing Lun (Chinese full name), Mike (English name)
Wong Hoi Sing (Chinese full name), Edison (English name)

Regards,
Edison

-----Original Message-----
From: joe@perches.com [mailto:joe@perches.com] 
Sent: Monday, August 13, 2007 2:37 PM
To: torvalds@linux-foundation.org; linux-kernel@vger.kernel.org; hswong3i@gmail.com; hlhung3i@gmail.com; akpm@linux-foundation.org
Subject: [PATCH] [470/2many] MAINTAINERS - TCP LOW PRIORITY MODULE

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index fc0589f..e45a848 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4462,12 +4462,13 @@ F:	include/net/pkt_cls.h
 F:	net/sched/
 
 TCP LOW PRIORITY MODULE
-P:	Wong Hoi Sing, Edison
+P:	Wong Hoi (Edison) Sing
 M:	hswong3i@gmail.com
-P:	Hung Hing Lun, Mike
+P:	Hung Hing (Mike) Lun
 M:	hlhung3i@gmail.com
 W:	http://tcp-lp-mod.sourceforge.net/
 S:	Maintained
+F:	net/ipv4/tcp_lp.c
 
 TI FLASH MEDIA INTERFACE DRIVER
 P:      Alex Dubov

