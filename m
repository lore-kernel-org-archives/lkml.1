Return-Path: <linux-kernel-owner+w=401wt.eu-S1758663AbXERN3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663AbXERN3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 09:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754997AbXERN3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 09:29:44 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:20923 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563AbXERN3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 09:29:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=W8/KLcyHuGyKUGSRAjF01lvIAPp9teNcP+dcBgtNW+jAWwom18ildTcA6wolMqKzbeLm3h1gw4ZZu9Zx7qcgzDmMH4uXNGxoQ38HVpgVefum0pM4GtA3hLEiUNZz4KO4Ehf4aK/NDeMEJPZHFN0Bi2Kot1cBpouvGVQ8BQf6X/c=
Message-ID: <f24d23310705180629x50c56ayfdcde357f0373fc4@mail.gmail.com>
Date: Fri, 18 May 2007 18:59:41 +0530
From: "debian developer" <debiandev@gmail.com>
To: greg@kroah.com, linux-kernel@vger.kernel.org, debiandev@gmail.com
Subject: [PATCH - 1/1] Documentation/HOWTO
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Heres a patch. It's my first. so any mistakes to be pardoned. :)

--- linux-2.6.21.1/Documentation/HOWTO.orig	2007-05-18 18:54:18.000000000 +0530
+++ linux-2.6.21.1/Documentation/HOWTO	2007-05-18 18:55:03.000000000 +0530
@@ -383,26 +383,6 @@ One of the best ways to put into practic
 bugs reported by other people. Not only you will help to make the kernel
 more stable, you'll learn to fix real world problems and you will improve
 your skills, and other developers will be aware of your presence. Fixing
-bugs is one of the best ways to earn merit amongst the developers, because
-not many people like wasting time fixing other people's bugs.
-
-To work in the already reported bug reports, go to http://bugzilla.kernel.org.
-If you want to be advised of the future bug reports, you can subscribe to the
-bugme-new mailing list (only new bug reports are mailed here) or to the
-bugme-janitor mailing list (every change in the bugzilla is mailed here)
-
-	http://lists.osdl.org/mailman/listinfo/bugme-new
-	http://lists.osdl.org/mailman/listinfo/bugme-janitors
-
-
-
-Managing bug reports
---------------------
-
-One of the best ways to put into practice your hacking skills is by fixing
-bugs reported by other people. Not only you will help to make the kernel
-more stable, you'll learn to fix real world problems and you will improve
-your skills, and other developers will be aware of your presence. Fixing
 bugs is one of the best ways to get merits among other developers, because
 not many people like wasting time fixing other people's bugs.
