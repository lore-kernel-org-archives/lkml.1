Return-Path: <linux-kernel-owner+w=401wt.eu-S1755165AbZAKNhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbZAKNhl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 08:37:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754151AbZAKNdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 08:33:50 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36653 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139AbZAKNds convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 08:33:48 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "David Miller" <davem@davemloft.net>, "Ingo Molnar" <mingo@elte.hu>,
       "Mike Travis" <travis@sgi.com>
References: <XU-8icArWLM.A.UpG.8GfaJB@chimera>
In-Reply-To: <XU-8icArWLM.A.UpG.8GfaJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <oWTznAnH9BI.A.s7G.CHfaJB@chimera>
Subject: [Bug #12427] cpumask change causes sparc build bustage
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 11 Jan 2009 12:16:29 +0100 (CET)
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
Date		: 2009-01-11 8:31 (1 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=588235bb53f2c215f0d4b08fd30b461fedc3338e
References	: http://marc.info/?l=linux-kernel&m=123166268013838&w=4
Handled-By	: David Miller <davem@davemloft.net>
Patch		: http://marc.info/?l=linux-kernel&m=123167571525706&w=4


