Return-Path: <linux-kernel-owner+w=401wt.eu-S934903AbXEHJvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934903AbXEHJvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 05:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934924AbXEHJvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 05:51:49 -0400
Received: from www.osadl.org ([213.239.205.134]:45552 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934909AbXEHJvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 05:51:45 -0400
Subject: Re: [PATCH 3/5] i386: hpet assumes boot cpu is 0
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Chris Wright <chrisw@sous-sol.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070508094450.GV3505@sequoia.sous-sol.org>
References: <1178485128.31213.98.camel@localhost.localdomain>
	 <20070507163110.GP3505@sequoia.sous-sol.org>
	 <1178556361.3042.16.camel@localhost.localdomain>
	 <20070508093957.GS3505@sequoia.sous-sol.org>
	 <20070508094450.GV3505@sequoia.sous-sol.org>
Content-Type: text/plain
Date: Tue, 08 May 2007 11:54:33 +0200
Message-Id: <1178618073.3042.316.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-08 at 02:44 -0700, Chris Wright wrote:
> I fixed this in x86_64.  Looks like the kind of thing that will break
> voyager on i386.

voyager has hpet ? Anyway good point.

	tglx


