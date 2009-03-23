Return-Path: <linux-kernel-owner+w=401wt.eu-S1760044AbZCWRKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760044AbZCWRKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 13:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755460AbZCWRKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 13:10:35 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:37935 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246AbZCWRKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 13:10:34 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; charset=us-ascii
Date: Mon, 23 Mar 2009 13:13:34 -0400
From: Jody McIntyre <scjody@sun.com>
Subject: [PATCH] trivial: fix orphan dates in ext2 documentation
In-reply-to: <20090323152003.GA1412@ucw.cz>
To: Pavel Machek <pavel@ucw.cz>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Message-id: <20090323171334.GD8294@clouds>
References: <20090312213922.GK8732@clouds> <20090323152003.GA1412@ucw.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Revert the change to the orphan dates of Windows 95, DOS, compression.  Add
a new orphan date for OS/2.

Signed-off-by: Jody McIntyre <scjody@sun.com>

Index: linux-2.6/Documentation/filesystems/ext2.txt
===================================================================
--- linux-2.6.orig/Documentation/filesystems/ext2.txt
+++ linux-2.6/Documentation/filesystems/ext2.txt
@@ -376,7 +376,8 @@ Implementations for:
 Windows 95/98/NT/2000	http://www.chrysocome.net/explore2fs
 Windows 95 (*)		http://www.yipton.net/content.html#FSDEXT2
 DOS client (*)		ftp://metalab.unc.edu/pub/Linux/system/filesystems/ext2/
-OS/2 (*)		ftp://metalab.unc.edu/pub/Linux/system/filesystems/ext2/
+OS/2 (+)		ftp://metalab.unc.edu/pub/Linux/system/filesystems/ext2/
 RISC OS client		http://www.esw-heim.tu-clausthal.de/~marco/smorbrod/IscaFS/
 
-(*) no longer actively developed/supported (as of Mar 2009)
+(*) no longer actively developed/supported (as of Apr 2001)
+(+) no longer actively developed/supported (as of Mar 2009)
