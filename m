Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbZJZTEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbZJZTEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755181AbZJZTEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:04:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59390 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754835AbZJZTE1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:04:27 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera>
In-Reply-To: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <6dRYo8ss7vL.A.zXG.dre5KB@chimera>
Subject: [Bug #14384] tbench regression with 2.6.32-rc1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 26 Oct 2009 19:55:55 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14384
Subject		: tbench regression with 2.6.32-rc1
Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Date		: 2009-10-09 9:51 (18 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=59abf02644c45f1591e1374ee7bb45dc757fcb88
References	: http://marc.info/?l=linux-kernel&m=125508216713138&w=4
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>


