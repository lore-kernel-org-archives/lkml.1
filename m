Return-Path: <linux-kernel-owner+w=401wt.eu-S932216AbXHKWvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216AbXHKWvq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 18:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763051AbXHKWvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 18:51:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:1241 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762681AbXHKWve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 18:51:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ZGYgwKfzBh9BVPhM0V3b3Xn9RC57hxDbiuyuMkOaBMHOkO2B+fWlM8g3kGQeGIg3kMYmr1ognhXb/yuh25VloPptCsyW5wvBWm4F/W3mA2+X8b9M2YiRqnoSR1Ej4RFpwDZMsKwJScWzLUsIMNMkZzX2Ni9dTfPLPZ+TN4mNnY4=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: linux-doc@vger.kernel.org
Subject: [PATCH 5/5] Add a 00-INDEX file to Documentation/watchdog/
Date: Sun, 12 Aug 2007 00:49:14 +0200
User-Agent: KMail/1.9.7
Cc: Rob Landley <rob@landley.net>, Randy Dunlap <rdunlap@xenotime.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Wim Van Sebroeck <wim@iguana.be>, Jesper Juhl <jesper.juhl@gmail.com>
References: <200708120045.03032.jesper.juhl@gmail.com>
In-Reply-To: <200708120045.03032.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708120049.14458.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Add a 00-INDEX file to Documentation/watchdog/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 00-INDEX |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- /dev/null	2005-11-21 04:22:37.000000000 +0100
+++ linux-2.6/Documentation/watchdog/00-INDEX	2007-08-12 00:06:01.000000000 +0200
@@ -0,0 +1,10 @@
+00-INDEX
+	- this file.
+pcwd-watchdog.txt
+	- documentation for Berkshire Products PC Watchdog ISA cards.
+src/
+	- directory holding watchdog related example programs.
+watchdog-api.txt
+	- description of the Linux Watchdog driver API.
+wdt.txt
+	- description of the Watchdog Timer Interfaces for Linux.



