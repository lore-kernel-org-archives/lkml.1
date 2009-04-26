Return-Path: <linux-kernel-owner+w=401wt.eu-S1753333AbZDZAgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbZDZAgV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 20:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbZDZAgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 20:36:13 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:60836 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654AbZDZAgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 20:36:12 -0400
Date: Sat, 25 Apr 2009 17:37:07 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #13107] LTP 20080131 causes defunct processes w/2.6.30-rc1
Message-ID: <20090426003707.GA4115@us.ibm.com>
References: <47KgT3nlbjD.A.lnB.jc48JB@chimera> <Fg2zLW93smL.A.Y3E.nd48JB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Fg2zLW93smL.A.Y3E.nd48JB@chimera>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki [rjw@sisk.pl] wrote:
| This message has been generated automatically as a part of a report
| of recent regressions.
| 
| The following bug entry is on the current list of known regressions
| from 2.6.29.  Please verify if it still should be listed and let me know
| (either way).
| 
| 
| Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13107
| Subject		: LTP 20080131 causes defunct processes w/2.6.30-rc1
| Submitter	: Kumar Gala <galak@kernel.crashing.org>
| Date		: 2009-04-09 15:43 (17 days old)
| First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b3bfa0cba867f23365b81658b47efd906830879b
| References	: http://marc.info/?l=linux-kernel&m=123929187208953&w=4
| 		  http://lkml.org/lkml/2009/4/10/193
| Handled-By	: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
| 

I don't beleive it is a regression.

Kumar can you confirm ?

Sukadev
