Return-Path: <linux-kernel-owner+w=401wt.eu-S1759164AbZEPXD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759164AbZEPXD5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 19:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757892AbZEPXAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 19:00:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44246 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757890AbZEPXAP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 19:00:15 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Maxim Levitsky" <maximlevitsky@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <yO1BmxN79sN.A.xAG.8_zDKB@chimera>
In-Reply-To: <yO1BmxN79sN.A.xAG.8_zDKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <pQ9WADCjgyE.A.V4G.UA0DKB@chimera>
Subject: [Bug #13100] can't anymore even do a s2ram-s2disk-s2ram cycle on acer aspire 5720G
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 16 May 2009 22:06:01 +0200 (CEST)
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
Date		: 2009-04-06 23:52 (41 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a0d4922da2e4ccb0973095d8d29f36f6b1b5f703
References	: http://marc.info/?l=linux-kernel&m=123906202829074&w=4
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>


