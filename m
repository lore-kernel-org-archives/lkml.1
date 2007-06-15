Return-Path: <linux-kernel-owner+w=401wt.eu-S1753557AbXFOJSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbXFOJSK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 05:18:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751097AbXFOJR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 05:17:58 -0400
Received: from canuck.infradead.org ([209.217.80.40]:43164 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbXFOJR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 05:17:57 -0400
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
From: David Woodhouse <dwmw2@infradead.org>
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
In-Reply-To: <200706150458.29943.dhazelton@enter.net>
References: <466A3EC6.6030706@netone.net.tr>
	 <200706142144.15695.dhazelton@enter.net>
	 <1181895924.25228.319.camel@pmac.infradead.org>
	 <200706150458.29943.dhazelton@enter.net>
Content-Type: text/plain
Date: Fri, 15 Jun 2007 10:17:44 +0100
Message-Id: <1181899064.25228.342.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-15 at 04:58 -0400, Daniel Hazelton wrote:
> > If the module is distributed 'as a separate work', _then_ what you say
> > is true: the only reason you'd have a right to the source is if the
> > module is considered a 'derivative work'.
> >
> > But when you distribute the same module as part of a whole which is a
> > work based on the kernel, the distribution of the whole must be on the
> > terms of GPL, whose permissions for other licensees extend to the entire
> > whole, and thus to each and every part regardless of who wrote it.
> 
> -ELOGIC

What's logic got to do with it? It was fairly much a direct quote from
the licence. You have _read_ the licence, haven't you?

> > The words you used were 'with the kernel', which could actually mean
> > either of the above. In the case of embedded Linux-based firmware
> > though, it's definitely the latter. It's a coherent whole, and it
> > contains both the kernel and the module. Thus the GPL extends to each
> > and every part, regardless of who wrote it. Including the module.
> 
> Just because two things are bundled together doesn't put them under the same 
> license or copyright. Take a look at the GPL, which specifically mentions 
> that "mere aggregation" does not cause something to fall under the GPL. Not 
> that the GPL can even change the law - in the US copyright law specifically 
> states that "mechanical translation" and "mechanical processes" *CANNOT* 
> create a "new" work. Since the process of compiling source into a binary is, 
> by definition, a *mechanical* process then the binary can't suddenly become 
> covered by a different copyright license than the source code merely because 
> of the medium on which its distributed or the manner in which it is 
> distributed.

You're confused.

If I grant you a licence on the condition that you give me money, would
you object on the basis that the money is not a 'derived work' of my
code? No. It's just a condition of the licence, and you're not allowed
to use my code unless you give me money.

If I grant you a licence on the condition that you sacrifice your
first-born son to Satan, would you object on the basis that your son is
not a 'derived work' of my code? No. It's just a condition of the
licence. If you don't do it, you don't have the right to use my code. 
(You may be able to get me locked up, but you still don't get to use my
code without a licence).

If I grant you a licence on the condition that you release _everything_
you write this year under the GPLv2, would you object on the basis that
your code is not a 'derived work' of my own? No. It's just a condition
of the licence, which you choose to accept or not.

If I grant you a licence on the condition that anything you release in
_combination_ with my code must also be released under the GPL, would
you object on the basis that you code is not a 'derived work' of my own?
No. Again, it's just a condition of the licence. If you don't want to
obey the licence, you don't get to use the kernel in the first place.

Talking about how your code can't possibly be a derived work is just a
red herring. The GPL explicitly talks about works which are 'independent
and separate works in themselves', to which the GPL does not apply 'when
you distribute them as separate works'.

But when you distribute the same sections as part of a whole which is a
work based on the Program, the distribution of the whole must be on the
terms of this License, whose permissions for other licensees extend to
the entire whole, and thus to each and every part regardless of who
wrote it.

It's your choice -- you're not _forced_ to use the kernel, and you're
not _forced_ to distribute a product which combines it with other code
of your own. But if you do, you're bound by the licence. And whether
your code is a 'derived work' has nothing to do with it.

Yes, there are exceptions for mere aggregation onto a storage medium --
if the kernel and your own work are next to each other on a backup tape
or your laptop's hard drive, or even both burned to a 'Gratis Software'
CD as _separate_ works, then that doesn't count. But we're talking about
a product which has a Linux kernel, a module built specifically for that
kernel, and cannot function unless both of them are present. That ain't
"mere aggregation on a storage medium".

-- 
dwmw2

