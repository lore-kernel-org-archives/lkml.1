Return-Path: <linux-kernel-owner+w=401wt.eu-S1751479AbXDMEnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479AbXDMEnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 00:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbXDMEnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 00:43:37 -0400
Received: from ik-out-1112.google.com ([66.249.90.178]:17613 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbXDMEng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 00:43:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DWiMY1gNTvy0Sr096TLSxf9nJeLZGTXtAKVOhUnYUTky+i9GFurhOO+53veX00f5B3z/uLd0Wv9Loe+Ksg4ABVavm9UL+9444Awcx7N+9kZp6OKWjlSO891FrtkaqkYRHSnIcVosP0uMnBezgU6Zy/uRNqV5Oy3cg85qdAuOFP8=
Message-ID: <653402b90704122143v2e28c71egec69b799e788870d@mail.gmail.com>
Date: Fri, 13 Apr 2007 06:43:33 +0200
From: "Miguel Ojeda" <maxextreme@gmail.com>
To: akpm@osdl.org
Subject: [PATCH Trivial Resend] [DOC] Add webpages' URL and summarize 3 lines.
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <653402b90704111646o6173ba60wbe7b884bf2f9e544@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <653402b90704111646o6173ba60wbe7b884bf2f9e544@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial patch, against -rc6. Please apply, thanks.
---

CREDITS:
 - Summarize 3 lines into one.
 - Add webpage.

MAINTAINERS:
 - Add auxdisplay drivers/tree webpages.

 CREDITS     |    7 +++----
 MAINTAINERS |    4 ++++
 2 files changed, 7 insertions(+), 4 deletions(-)

Signed-off-by: Miguel Ojeda Sandonis <maxextreme@gmail.com>
---
diff --git a/CREDITS b/CREDITS
index 6bd8ab8..f990730 100644
--- a/CREDITS
+++ b/CREDITS
@@ -2573,10 +2573,9 @@ S: Australia

 N: Miguel Ojeda Sandonis
 E: maxextreme@gmail.com
-D: Author: Auxiliary LCD Controller driver (ks0108)
-D: Author: Auxiliary LCD driver (cfag12864b)
-D: Author: Auxiliary LCD framebuffer driver (cfag12864bfb)
-D: Maintainer: Auxiliary display drivers tree (drivers/auxdisplay/*)
+W: http://maxextreme.googlepages.com/
+D: Author of the ks0108, cfag12864b and cfag12864bfb auxiliary display drivers.
+D: Maintainer of the auxiliary display drivers tree (drivers/auxdisplay/*)
 S: C/ Mieses 20, 9-B
 S: Valladolid 47009
 S: Spain
diff --git a/MAINTAINERS b/MAINTAINERS
index 829407f..2a658ef 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -672,6 +672,7 @@ AUXILIARY DISPLAY DRIVERS
 P:	Miguel Ojeda Sandonis
 M:	maxextreme@gmail.com
 L:	linux-kernel@vger.kernel.org
+W:	http://auxdisplay.googlepages.com/
 S:	Maintained

 AVR32 ARCHITECTURE
@@ -884,12 +885,14 @@ CFAG12864B LCD DRIVER
 P:	Miguel Ojeda Sandonis
 M:	maxextreme@gmail.com
 L:	linux-kernel@vger.kernel.org
+W:	http://auxdisplay.googlepages.com/
 S:	Maintained

 CFAG12864BFB LCD FRAMEBUFFER DRIVER
 P:	Miguel Ojeda Sandonis
 M:	maxextreme@gmail.com
 L:	linux-kernel@vger.kernel.org
+W:	http://auxdisplay.googlepages.com/
 S:	Maintained

 COMMON INTERNET FILE SYSTEM (CIFS)
@@ -2020,6 +2023,7 @@ KS0108 LCD CONTROLLER DRIVER
 P:	Miguel Ojeda Sandonis
 M:	maxextreme@gmail.com
 L:	linux-kernel@vger.kernel.org
+W:	http://auxdisplay.googlepages.com/
 S:	Maintained

 LAPB module

-- 
Miguel Ojeda
http://maxextreme.googlepages.com/index.htm
