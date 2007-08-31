Return-Path: <linux-kernel-owner+w=401wt.eu-S966262AbXHaVYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966262AbXHaVYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 17:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966212AbXHaVYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 17:24:18 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:25389 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965889AbXHaVYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 17:24:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:user-agent:cc:references:in-reply-to:mime-version:content-disposition:date:content-type:content-transfer-encoding:message-id;
        b=WC+9NngFyZlVGnDRV5ITS9hRGeukPREvmt2V5E99M6TRzhyAnpvgKfirrnWQM2YAtvQb/yTmyqDzuPRWgKhAF7e1C0VCc+y7wDXfYB9uSuT05mowCu0j+dizU4nDnmxHdOh6M6Ci0hL2MkaHyDbmjUhTTYVDnK4UIPc2aU+9aB8=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: linux-doc@vger.kernel.org
Subject: [PATCH 2/5][resend] Add a 00-INDEX file to Documentation/mips/
User-Agent: KMail/1.9.7
Cc: Rob Landley <rob@landley.net>, Randy Dunlap <rdunlap@xenotime.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ralf Baechle <ralf@linux-mips.org>, Jesper Juhl <jesper.juhl@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200708120045.03032.jesper.juhl@gmail.com>
In-Reply-To: <200708120045.03032.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Date: Fri, 31 Aug 2007 23:21:11 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200708312321.11202.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Add a 00-INDEX file to Documentation/mips/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 00-INDEX |    8 ++++++++
 1 file changed, 8 insertions(+)

--- /dev/null	2005-11-21 04:22:37.000000000 +0100
+++ linux-2.6/Documentation/mips/00-INDEX	2007-08-11 22:56:26.000000000 +0200
@@ -0,0 +1,8 @@
+00-INDEX
+	- this file.
+AU1xxx_IDE.README
+	- README for MIPS AU1XXX IDE driver.
+GT64120.README
+	- README for dir with info on MIPS boards using GT-64120 or GT-64120A.
+time.README
+	- README for MIPS time services.



