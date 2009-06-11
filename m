Return-Path: <linux-kernel-owner+w=401wt.eu-S1760053AbZFKWuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760053AbZFKWuj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 18:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758420AbZFKWub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 18:50:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56315 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757552AbZFKWua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 18:50:30 -0400
Date: Thu, 11 Jun 2009 15:49:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Jiri Slaby <jirislaby@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Marcel Holtmann <marcel@holtmann.org>, Ingo Molnar <mingo@elte.hu>,
       Martin Bligh <mbligh@google.com>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Al Viro <viro@zeniv.linux.org.uk>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] Performance Counters for Linux
In-Reply-To: <20090611233803.4876b1fb@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.01.0906111548250.3535@localhost.localdomain>
References: <20090611165226.GV8633@ZenIV.linux.org.uk> <1244739378.6691.540.camel@laptop> <20090611170015.GA3651@infradead.org> <alpine.LFD.2.01.0906111005020.3573@localhost.localdomain> <33307c790906111124m17e57332oc38c89fa70e39231@mail.gmail.com>
 <alpine.LFD.2.01.0906111127520.3573@localhost.localdomain> <20090611202341.GA23590@elte.hu> <1244753357.27363.82.camel@violet> <20090611210810.GA9317@uranus.ravnborg.org> <1244755036.27363.93.camel@violet> <20090611212635.GA9446@uranus.ravnborg.org>
 <4A3182C6.803@gmail.com> <alpine.LFD.2.01.0906111521210.3535@localhost.localdomain> <20090611233803.4876b1fb@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 11 Jun 2009, Alan Cox wrote:
> 
> That misses the point, at least for the systems as the work now. Having a
> single source package to multiple binaries is easy. Managing setups where
> you push only some of those binaries into the system gets really ugly.

Umm. But what's the problem?

Sure, you'd always update the 'kernel-perftool' package (or whatever you'd 
call it) when you update the kernel. But so what? It's going to be tiny. 
And appropriate.

IOW, where's the downside?

			Linus
