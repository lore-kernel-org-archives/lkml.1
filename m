Return-Path: <linux-kernel-owner+w=401wt.eu-S932173AbXDKXqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbXDKXqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 19:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932179AbXDKXqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 19:46:47 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:63809 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932173AbXDKXqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 19:46:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=MiIQuZVhMmLZudXbcdIBO0+gEj7Z3Ab/gKuJRvtWYvfE7BA3I3aUW8PmshsuEwOGlPQeMozPEk9yuW2g6PelF0rmLbhuDERcXV+TT6o5lAd+XTy0YuozFWbF+3GxUktwwSRmu9XuhzF2uzWtHwwlsED+LN3VO4aFnGwklZWNids=
Message-ID: <653402b90704111646o6173ba60wbe7b884bf2f9e544@mail.gmail.com>
Date: Thu, 12 Apr 2007 01:46:45 +0200
From: "Miguel Ojeda" <maxextreme@gmail.com>
To: akpm@osdl.org
Subject: [PATCH] [Trivial] [Doc] Add webpages' URL and summarize 3 lines.
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
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
