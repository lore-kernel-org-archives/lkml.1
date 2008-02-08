Return-Path: <linux-kernel-owner+w=401wt.eu-S933447AbYBHJxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933447AbYBHJxO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 04:53:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932611AbYBHJw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 04:52:57 -0500
Received: from lizzard.sbs.de ([194.138.37.39]:20471 "EHLO lizzard.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932608AbYBHJw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 04:52:56 -0500
Message-ID: <47AC2631.9080702@siemens.com>
Date: Fri, 08 Feb 2008 10:51:45 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Phil Oester <kernel@linuxace.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [git pull] x86 arch updates for v2.6.25
References: <20080130011550.GA31853@elte.hu> <200802050436.31070.maximlevitsky@gmail.com> <alpine.LFD.1.00.0802041922300.3237@woody.linux-foundation.org> <20080205041103.GA11240@linuxace.com> <20080208044800.GA32709@infradead.org>
In-Reply-To: <20080208044800.GA32709@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

Christoph Hellwig wrote:
> But kgdb traditionally was more than just a simple gdb stub and
> contained hooks all over the place for additional functionality.
> I don't think all this is a good idea and I'd be against it.
> 
> I'd be really happy to see a common gdb stub with small arch support
> that allows attaching gdb to the kernel through various transports.
> 
> Maybe someone is up to do just that?  Even the full blown kgdb with
> all the hooks would benefit from having the gdb stub already in,
> so maybe I could motivate some kgdb developers to do that work?

For sure, every small step forward will help.

Maybe you could have a look at current kgdb.git at kernel.org and
comment on what you would like to see in a first submission round, what
kind of hooks, specifically regarding the core, are not yet in an
acceptable state, and so forth. We will listen.

TiA,
Jan

-- 
Siemens AG, Corporate Technology, CT SE 2
Corporate Competence Center Embedded Linux
