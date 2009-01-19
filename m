Return-Path: <linux-kernel-owner+w=401wt.eu-S1761544AbZASXzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761544AbZASXzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 18:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760698AbZASXw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 18:52:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40309 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760687AbZASXw0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 18:52:26 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "David Miller" <davem@davemloft.net>, "Ingo Molnar" <mingo@elte.hu>,
       "Mike Travis" <travis@sgi.com>
References: <0GOi9pntEoL.A.iGF.B9QdJB@chimera>
In-Reply-To: <0GOi9pntEoL.A.iGF.B9QdJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <2QN7KFic7LG.A.swH.29QdJB@chimera>
Subject: [Bug #12427] cpumask change causes sparc build bustage
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 19 Jan 2009 22:32:13 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12427
Subject		: cpumask change causes sparc build bustage
Submitter	: David Miller <davem@davemloft.net>
Date		: 2009-01-11 8:31 (9 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=588235bb53f2c215f0d4b08fd30b461fedc3338e
References	: http://marc.info/?l=linux-kernel&m=123166268013838&w=4
Handled-By	: David Miller <davem@davemloft.net>
Patch		: http://marc.info/?l=linux-kernel&m=123167571525706&w=4


