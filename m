Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbYFQLhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbYFQLhw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 07:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755105AbYFQLhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 07:37:42 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:23728 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757668AbYFQLhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 07:37:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:content-type
         :content-transfer-encoding:from;
        b=i6K6oLQhhIFQmRWi7c5IHanPg1UGQ2zNu3UfNqKuntR/NwXiooo1o6WMXYRLI05Cu5
         nN5kuBzaCZf8yVA7q8DTAcitbxokFrQe1vkO+aQpK9PqK6XxegMgTO3utrVJiRy5dc6U
         NCck43QS8/BuQGekjdzcIX5b4ebOff04u5fiQ=
Message-ID: <4857A1D6.2080600@gmail.com>
Date: Tue, 17 Jun 2008 13:36:54 +0200
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-doc@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       mpm@selenic.com, Randy Dunlap <rdunlap@xenotime.net>,
       tech-board@lists.linux-foundation.org,
       Jim Zemlin <jzemlin@linux-foundation.org>
Subject: [patch] MAINTAINERS -- Documentation
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Could you apply this patch for MAINTAINERS.  At this stage, I doubt that I'll
be doing much in terms of writing new documents or trying to fix
/Documentation as a whole, but I'm very willing to provide review and
editorial assistance for people contributing changes to /Documentation, and
even prod them in that direction if something is in need of documentation.

Cheers,

Michael

--- linux-2.6.26-rc5/MAINTAINERS.old.26-2008-06-17 11:19:01.000000000 +0200
+++ linux-2.6.26-rc5/MAINTAINERS        2008-06-17 11:22:36.000000000 +0200
@@ -1419,6 +1419,12 @@
 L:     linux-acpi@vger.kernel.org
 S:     Supported

+DOCUMENTATION (/Documentation directory)
+P:     Michael Kerrisk
+M:     mtk.manpages@gmail.com
+L:     linux-doc@vger.kernel.org
+S:     Maintained
+
 DOUBLETALK DRIVER
 P:     James R. Van Zandt
 M:     jrv@vanzandt.mv.com

