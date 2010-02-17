Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab0BQSll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 13:41:41 -0500
Received: from mail-pz0-f187.google.com ([209.85.222.187]:34363 "EHLO
	mail-pz0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680Ab0BQSlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 13:41:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=n2nXphW8/3nseh05Zbt0zFSoCo3RWN/zu06t/1YhoZxPDplv8enCoWvwLwL9CEFsAQ
         7F8j1p2LKP4RQhv1M60yHNMKEPqi+OamYaLcCaQTkcsa3o1xKLb3I3TwHrvShVOSdhsK
         Jbg95A8GLCXS5ISwOQVYCoxoBHmugViTHObCo=
MIME-Version: 1.0
From: Mulyadi Santosa <mulyadi.santosa@gmail.com>
Date: Thu, 18 Feb 2010 01:41:18 +0700
Message-ID: <f284c33d1002171041t337985eend78ff1cb531d74b2@mail.gmail.com>
Subject: [PATCH] Fixes a wrong table description in proc.txt documentation
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes a typo in proc.txt documentation. Table 1-2 should refer to
"status", not "statm"

Signed-off-by: Mulyadi Santosa <mulyadi.santosa@gmail.com>

---
 Documentation/filesystems/proc.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- Documentation/filesystems/proc.txt.bak	2009-12-10 21:08:25.000000000 +0700
+++ Documentation/filesystems/proc.txt	2010-02-09 21:09:14.000000000 +0700
@@ -188,7 +188,7 @@
 contains details information about the process itself.  Its fields are
 explained in Table 1-4.

-Table 1-2: Contents of the statm files (as of 2.6.30-rc7)
+Table 1-2: Contents of the status files (as of 2.6.30-rc7)
 ..............................................................................
  Field                       Content
  Name                        filename of the executable
