Return-Path: <linux-kernel-owner+w=401wt.eu-S1755221AbXEGXNC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbXEGXNC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 19:13:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755194AbXEGXNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 19:13:00 -0400
Received: from www.osadl.org ([213.239.205.134]:58344 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755185AbXEGXM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 19:12:59 -0400
Subject: Re: [PATCH] x86-64 highres/dyntick support
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070507224333.GA14623@linux-os.sc.intel.com>
References: <1178485128.31213.98.camel@localhost.localdomain>
	 <20070507224333.GA14623@linux-os.sc.intel.com>
Content-Type: text/plain
Date: Tue, 08 May 2007 01:15:45 +0200
Message-Id: <1178579745.3042.68.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-07 at 15:43 -0700, Venki Pallipadi wrote:
> Needs this minor fix to build on i386.

Ouch. 

Should have compiled i386 myself once more. There is another fixlet
missing in x86_64, which was caused by my inability to cope with the
intellegence of quilt.

Updated patches uploaded to:

http://www.tglx.de/projects/hrtimers/2.6.21-git2-x86-64/

	tglx


