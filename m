Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067Ab0AJWop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab0AJWop (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 17:44:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304Ab0AJWom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 17:44:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57942 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754307Ab0AJWlc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 17:41:32 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alex Chiang" <achiang@hp.com>, "Len Brown" <lenb@kernel.org>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>
In-Reply-To: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <omZ8aBZReyD.A.nGH.HNlSLB@chimera>
Subject: [Bug #14954] warning from alloc_pages_nodemask on boot -- caused by commit 78f1699659963fff97975df44db6d5dbe7218e55
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 10 Jan 2010 23:32:56 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14954
Subject		: warning from alloc_pages_nodemask on boot -- caused by commit 78f1699659963fff97975df44db6d5dbe7218e55
Submitter	: Stephen Hemminger <shemminger@linux-foundation.org>
Date		: 2009-12-29 19:57 (13 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=78f1699659963fff97975df44db6d5dbe7218e55
Handled-By	: Alex Chiang <achiang@hp.com>


