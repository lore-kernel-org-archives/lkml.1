Return-Path: <linux-kernel-owner+w=401wt.eu-S1765617AbXHDSgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765617AbXHDSgQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 14:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932581AbXHDSd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 14:33:29 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:45415 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528AbXHDSd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 14:33:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:user-agent:cc:mime-version:content-disposition:date:content-type:content-transfer-encoding:message-id;
        b=hyCDQdYd7clNaajccXnOIt1BcdanDgTICBT/tt4dStXk1DccawPZs/koJv8ANjTLer+kMK6NLUiA5cOvxK4ridHL4rG4UbeJAS2X47dO2KWHdIei1eebZuQtKbKM2FobhexUBrL7gDkvN06knw9o9piOYQMP9ctYG9fuemtebLY=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH][RESEND] Clarify the GPL version of contributions by Jesper Juhl in CREDITS
User-Agent: KMail/1.9.7
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trivial@kernel.org, Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Date: Sat, 4 Aug 2007 20:31:32 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200708042031.32704.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(resending trivial patch, originally from 18/6-2007 02:33)


Just to make things clear in the light of recent discussions about 
licensing. 
Stuff I contribute to the Linux kernel are licensed under the terms of the 
GPL version 2.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 CREDITS                       |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/CREDITS b/CREDITS
index 273d72b..4a56f2a 100644
--- a/CREDITS
+++ b/CREDITS
@@ -1639,6 +1639,7 @@ N: Jesper Juhl
 E: jesper.juhl@gmail.com
 D: Various fixes, cleanups and minor features all over the tree.
 D: Wrote initial version of the hdaps driver (since passed on to others).
+D: All contributions are licensed under the terms of the GPL version 2.
 S: Lemnosvej 1, 3.tv
 S: 2300 Copenhagen S.
 S: Denmark
