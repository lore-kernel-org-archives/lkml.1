Return-Path: <linux-kernel-owner+w=401wt.eu-S1762029AbZDQQxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762029AbZDQQxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 12:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755744AbZDQQxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 12:53:42 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:34796 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754425AbZDQQxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 12:53:41 -0400
Date: Fri, 17 Apr 2009 09:55:14 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #13107] LTP 20080131 causes defunct processes w/2.6.30-rc1
Message-ID: <20090417165514.GB10256@us.ibm.com>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <nY3-4PrO6XH.A.8j.Xw85JB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nY3-4PrO6XH.A.8j.Xw85JB@chimera>
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
| Date		: 2009-04-09 15:43 (8 days old)
| First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b3bfa0cba867f23365b81658b47efd906830879b
| References	: http://marc.info/?l=linux-kernel&m=123929187208953&w=4
| Handled-By	: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
| 

The last response to this was: http://lkml.org/lkml/2009/4/10/193.
So it was not clear if the init was being ptraced or it got the SIGSTOP
from parent namespace.

Kumar, any update on this ?

Sukadev
