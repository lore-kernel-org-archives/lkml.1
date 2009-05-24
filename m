Return-Path: <linux-kernel-owner+w=401wt.eu-S1759327AbZEXWaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759327AbZEXWaN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 18:30:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759287AbZEXW1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 18:27:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34500 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759210AbZEXW1m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 18:27:42 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Maxim Levitsky" <maximlevitsky@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <GtY7d2eWpoK.A.ioC.MQcGKB@chimera>
In-Reply-To: <GtY7d2eWpoK.A.ioC.MQcGKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <WCcYF-TAbJC.A.etD.rQcGKB@chimera>
Subject: [Bug #13100] can't anymore even do a s2ram-s2disk-s2ram cycle on acer aspire 5720G
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 24 May 2009 21:31:17 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.28 and 2.6.29.

The following bug entry is on the current list of known regressions
introduced between 2.6.28 and 2.6.29.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13100
Subject		: can't anymore even do a s2ram-s2disk-s2ram cycle on acer aspire 5720G
Submitter	: Maxim Levitsky <maximlevitsky@gmail.com>
Date		: 2009-04-06 23:52 (49 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a0d4922da2e4ccb0973095d8d29f36f6b1b5f703
References	: http://marc.info/?l=linux-kernel&m=123906202829074&w=4
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>


