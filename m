Return-Path: <linux-kernel-owner+w=401wt.eu-S1757307AbZEPWQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbZEPWQd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 18:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757557AbZEPWOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 18:14:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43857 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757461AbZEPWOh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 18:14:37 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alexander Beregalov" <a.beregalov@gmail.com>,
       "Jeff Mahoney" <jeffm@suse.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
In-Reply-To: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <385Pu-agh7M.A.sNC.mZzDKB@chimera>
Subject: [Bug #13122] reiserfs_delete_xattrs: Couldn't delete all xattrs (-13)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 16 May 2009 21:20:38 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13122
Subject		: reiserfs_delete_xattrs: Couldn't delete all xattrs (-13)
Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
Date		: 2009-04-16 19:23 (31 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d984561b326cd0fe0d1183d11b9b4fa1d011d21d
References	: http://marc.info/?l=linux-kernel&m=123990989515105&w=4
Handled-By	: Jeff Mahoney <jeffm@suse.com>
Patch		: http://lkml.org/lkml/2009/5/10/91


