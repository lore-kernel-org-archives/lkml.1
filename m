Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab0BIO0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 09:26:12 -0500
Received: from mail-yw0-f173.google.com ([209.85.211.173]:48913 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181Ab0BIO0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 09:26:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=kk8KnOF8VkMmw2OlCYNd02PKcj6eSvwBJEvRangbSmhTe38ZtZkFG8OxZ2kROVVMCg
         4FWIMDxSJCE794E+XbKs7c4Dd/thDLhUxsJJHJcd2s9BYgbcjXYaVUY24UP0hcRBHpXO
         ZvfWv+5NTu2P0T+yVDA69pjgY6dNHx4gG9jO8=
MIME-Version: 1.0
From: Mulyadi Santosa <mulyadi.santosa@gmail.com>
Date: Tue, 9 Feb 2010 21:25:48 +0700
Message-ID: <f284c33d1002090625ydfb6b2dq462a2124d2fbebe@mail.gmail.com>
Subject: [patch] Documentation typo - Table 1-2 should refer to "status", not 
	"statm"
To: comandante@zaralinux.com, bb@ricochet.net
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
