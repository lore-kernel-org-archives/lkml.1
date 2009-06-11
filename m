Return-Path: <linux-kernel-owner+w=401wt.eu-S1756758AbZFKSjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbZFKSjD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 14:39:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754178AbZFKSiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 14:38:54 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:48896 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbZFKSiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 14:38:54 -0400
Message-ID: <4A314F37.2080202@davidnewall.com>
Date: Fri, 12 Jun 2009 04:08:47 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] Performance Counters for Linux
References: <20090611160329.GA3366@elte.hu>  <20090611161714.GA5008@infradead.org>  <alpine.LFD.2.01.0906110922080.3573@localhost.localdomain>  <20090611165226.GV8633@ZenIV.linux.org.uk>  <1244739378.6691.540.camel@laptop>  <20090611170015.GA3651@infradead.org>  <alpine.LFD.2.01.0906111005020.3573@localhost.localdomain> <84144f020906111059g6e25a090y4434cfd698f84fb4@mail.gmail.com> <4A3148AA.9000007@davidnewall.com> <alpine.LFD.2.01.0906111120100.3573@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0906111120100.3573@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> I note (once more) how _nobody_ has actually been able to accept the 
> fact that oprofile was an abject failure as it was split up. Instead, you 
> all dance around totally irrelevant issues.

Not I. I'm totally comfortable with your decision, even though it seems
counter- to your own stated policy.

While I'm still unable to help noticing things, nobody seems to have
presented an argument that user-space and kernel-side will need to be
developed together. There's been an obvious assumption, with oprofile
given as that assumption's poster-boy, but why that should be the case
for tools/perf remains unclear. Probably the reasons are so obvious that
they go without saying, but as a disinterested observer, it seems to me
that in this case the two sides really are quite separate and
independent in a very real sense. Perhaps in the same sense that acct
and quota are.
