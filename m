Return-Path: <linux-kernel-owner+w=401wt.eu-S1758923AbXFGLI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758923AbXFGLI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 07:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbXFGLIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 07:08:48 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:6412 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbXFGLIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 07:08:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=sCQeTpRwqbHPruiw4aZGCXEPrRJpGXv6pn9mWkdULDCY4nyAFEvExPNf6f3JBnCScapKNKKKdrBG1xGnv7N5/F1tVsyJi6AWqjFUM4MZvIJ4ARx8dHK23yvJlMf4vyDgnoaGpmLvQGykAsM7C7qTGMrxaM7a+B++UGP5snRCWgI=
Message-ID: <a781481a0706070408qb5f13eexba0f7f80ef756cf9@mail.gmail.com>
Date: Thu, 7 Jun 2007 16:38:46 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH (trivial)] Fix typo in Documentation/keys.txt
Cc: "David Howells" <dhowells@redhat.com>, trivial@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a typo in Documentation/keys.txt.

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: David Howells <dhowells@redhat.com>
Cc: trivial@kernel.org

---

 Documentation/keys.txt |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

---

diff -ruNp a/Documentation/keys.txt b/Documentation/keys.txt
--- a/Documentation/keys.txt	2007-06-03 02:33:02.000000000 +0530
+++ b/Documentation/keys.txt	2007-06-03 02:38:52.000000000 +0530
@@ -859,9 +859,8 @@ payload contents" for more information.
 	void unregister_key_type(struct key_type *type);


-Under some circumstances, it may be desirable to desirable to deal with a
-bundle of keys.  The facility provides access to the keyring type for managing
-such a bundle:
+Under some circumstances, it may be desirable to deal with a bundle of keys.
+The facility provides access to the keyring type for managing such a bundle:

 	struct key_type key_type_keyring;
