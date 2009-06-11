Return-Path: <linux-kernel-owner+w=401wt.eu-S1760195AbZFKVGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760195AbZFKVGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 17:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759962AbZFKVF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 17:05:56 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:44652 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759263AbZFKVFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 17:05:54 -0400
Date: Thu, 11 Jun 2009 23:08:10 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Bligh <mbligh@google.com>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Al Viro <viro@zeniv.linux.org.uk>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] Performance Counters for Linux
Message-ID: <20090611210810.GA9317@uranus.ravnborg.org>
References: <20090611161714.GA5008@infradead.org> <alpine.LFD.2.01.0906110922080.3573@localhost.localdomain> <20090611165226.GV8633@ZenIV.linux.org.uk> <1244739378.6691.540.camel@laptop> <20090611170015.GA3651@infradead.org> <alpine.LFD.2.01.0906111005020.3573@localhost.localdomain> <33307c790906111124m17e57332oc38c89fa70e39231@mail.gmail.com> <alpine.LFD.2.01.0906111127520.3573@localhost.localdomain> <20090611202341.GA23590@elte.hu> <1244753357.27363.82.camel@violet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244753357.27363.82.camel@violet>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> So you are saying that only good code comes from including it into
> linux-2.6.git and otherwise you will never get there. Have you actually
> tried to maintain this in a separate repository on kernel.org?

Could you please remind us what the arguments agains including a few
seleted tools within the kernel source tree was.

I ask because I really cannot see why so much nosie is generated?
As a naive user that like easy access to the stuff I work with
this looks like an optimal place to find the kernel-hacking
tools I need. Why should I hunt somewhere else to find it?

	Sam
