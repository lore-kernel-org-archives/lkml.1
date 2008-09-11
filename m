Return-Path: <linux-kernel-owner+w=401wt.eu-S1754458AbYIKKnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458AbYIKKnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 06:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752357AbYIKKnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 06:43:10 -0400
Received: from hs-out-0708.google.com ([64.233.178.244]:9708 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbYIKKnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 06:43:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:message-id:date:from;
        b=SNAaBcavr12EPU63jSwq3yKah9Jqm8SG+PYRXUztPVbz6nggAqI/IXI8VuQRKityhm
         2WG5cBEpW431HN1jUci7boWwGWB8DzA3V3vebooRLpZbulOMejhilpWf3QDsmaJqv+YD
         lRB41cWR5z3dk67qT3t92cszlIPaY+qS9HY2o=
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
       mtk.manpages@gmail.com, rdunlap@xenotime.net, trivial@kernel.org
Subject: [PATCH] doc: typo in Documentation/filesystems/nfsroot.txt
Message-Id: <E1Kdjdd-0007lc-Nc@localhost>
Date: Thu, 11 Sep 2008 04:43:01 -0600
From: Shane McDonald <mcdonald.shane@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a trivial patch to add a missing word to the explanation
of the purpose of the zdisk and bzdisk make targets.

Signed-off-by: Shane McDonald <mcdonald.shane@gmail.com>
---
 Documentation/filesystems/nfsroot.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -uprN orig/Documentation/filesystems/nfsroot.txt patched/Documentation/filesystems/nfsroot.txt
--- orig/Documentation/filesystems/nfsroot.txt	2008-09-11 04:03:55.000000000 -0600
+++ patched/Documentation/filesystems/nfsroot.txt	2008-09-11 04:09:51.000000000 -0600
@@ -169,7 +169,7 @@ They depend on various facilities being 
 3.1)  Booting from a floppy using syslinux
 
 	When building kernels, an easy way to create a boot floppy that uses
-	syslinux is to use the zdisk or bzdisk make targets which use
+	syslinux is to use the zdisk or bzdisk make targets which use zimage
       	and bzimage images respectively. Both targets accept the
      	FDARGS parameter which can be used to set the kernel command line.
 
