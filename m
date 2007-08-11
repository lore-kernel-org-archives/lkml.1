Return-Path: <linux-kernel-owner+w=401wt.eu-S1764915AbXHKWsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764915AbXHKWsn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 18:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762390AbXHKWsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 18:48:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:65096 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759200AbXHKWsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 18:48:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=h6UqJmVL8cpLZZjIDgcQpdGn/a2jaz6OSF2DuZE/J7hm/OmFLQh1kS7J7FnRGKQhNdMbnbYlbFpR6EV4IfHfEJ4b1TZih9YPdkVM3cKX0y0kbLoHzHvGAKDfE6QfeTwsZVxo/I+NziGIv904jEhyMKprwNh51ISDTqtGEh70BIo=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: linux-doc@vger.kernel.org
Subject: [PATCH 1/5] Add a 00-INDEX file to Documentation/auxdisplay/
Date: Sun, 12 Aug 2007 00:46:14 +0200
User-Agent: KMail/1.9.7
Cc: Rob Landley <rob@landley.net>, Randy Dunlap <rdunlap@xenotime.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Miguel Ojeda Sandonis <maxextreme@gmail.com>,
       Jesper Juhl <jesper.juhl@gmail.com>
References: <200708120045.03032.jesper.juhl@gmail.com>
In-Reply-To: <200708120045.03032.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708120046.15100.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Add a 00-INDEX file to Documentation/auxdisplay/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 00-INDEX |    8 ++++++++
 1 file changed, 8 insertions(+)

--- /dev/null	2005-11-21 04:22:37.000000000 +0100
+++ linux-2.6/Documentation/auxdisplay/00-INDEX	2007-08-11 23:58:49.000000000 +0200
@@ -0,0 +1,8 @@
+00-INDEX
+	- this file.
+cfag12864b
+	- documentation for the cfag12864b LCD driver.
+cfag12864b-example.c
+	- cfag12864b LCD userspace example program.
+ks0108
+	- documentation for the ks0108 LCD controller driver.


