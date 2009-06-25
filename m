Return-Path: <linux-kernel-owner+w=401wt.eu-S1756002AbZFYS1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbZFYS1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 14:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753748AbZFYS1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 14:27:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44536 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752977AbZFYS1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 14:27:35 -0400
Date: Thu, 25 Jun 2009 11:26:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [GIT pull] final futex fixes for 2.6.31
In-Reply-To: <alpine.LFD.2.00.0906251940570.2767@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0906251125150.3605@localhost.localdomain>
References: <alpine.LFD.2.00.0906241629590.2767@localhost.localdomain> <alpine.LFD.2.01.0906240946000.3240@localhost.localdomain> <alpine.LFD.2.00.0906242146500.2767@localhost.localdomain> <1245897826.2560.421.camel@ymzhang> <alpine.LFD.2.00.0906251151400.2767@localhost.localdomain>
 <20090625100413.GD29980@elte.hu> <alpine.LFD.2.00.0906251940570.2767@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Jun 2009, Thomas Gleixner wrote:
> 
> I'm truly embarrassed to ask you to pull the latest futexes-for-linus
> git tree from:

No problem. It was a harmless bug (at worst we'd do some extra work), and 
I made the same mistake, so I can't blame you.

And I merged Peter's prototype clarification so that next time there will 
be less reason for this to happen.

		Linus
