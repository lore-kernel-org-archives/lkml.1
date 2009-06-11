Return-Path: <linux-kernel-owner+w=401wt.eu-S1760842AbZFKTY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760842AbZFKTY7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 15:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760614AbZFKTYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 15:24:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758410AbZFKTYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 15:24:46 -0400
Date: Thu, 11 Jun 2009 12:23:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Newall <davidn@davidnewall.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] Performance Counters for Linux
In-Reply-To: <4A3155E3.3030603@davidnewall.com>
Message-ID: <alpine.LFD.2.01.0906111223250.3573@localhost.localdomain>
References: <20090611160329.GA3366@elte.hu>  <20090611161714.GA5008@infradead.org>  <alpine.LFD.2.01.0906110922080.3573@localhost.localdomain>  <20090611165226.GV8633@ZenIV.linux.org.uk>  <1244739378.6691.540.camel@laptop>  <20090611170015.GA3651@infradead.org>
  <alpine.LFD.2.01.0906111005020.3573@localhost.localdomain> <84144f020906111059g6e25a090y4434cfd698f84fb4@mail.gmail.com> <4A3148AA.9000007@davidnewall.com> <alpine.LFD.2.01.0906111120100.3573@localhost.localdomain> <4A314F37.2080202@davidnewall.com>
 <alpine.LFD.2.01.0906111142390.3573@localhost.localdomain> <4A3155E3.3030603@davidnewall.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 12 Jun 2009, David Newall wrote:
> 
> You seem to be saying that putting the code in kernel tree will make
> user-level developers more responsive. FWIW (very little) I would have
> quietly guessed the opposite result.

No. I'm saying that if there's a big overlap with _kernel_ developers 
(which there is), then they can maintain the tree.

		Linus
