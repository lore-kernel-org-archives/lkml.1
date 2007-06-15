Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbXFOI6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbXFOI6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 04:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbXFOI6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 04:58:44 -0400
Received: from keil-draco.com ([216.193.185.50]:50890 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbXFOI6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 04:58:43 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Fri, 15 Jun 2007 04:58:29 -0400
User-Agent: KMail/1.9.6
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
References: <466A3EC6.6030706@netone.net.tr> <200706142144.15695.dhazelton@enter.net> <1181895924.25228.319.camel@pmac.infradead.org>
In-Reply-To: <1181895924.25228.319.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706150458.29943.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 June 2007 04:25:24 David Woodhouse wrote:
> On Thu, 2007-06-14 at 21:44 -0400, Daniel Hazelton wrote:
> > Agreed. I said I wasn't going to argue about it because there *ARE*
> > distinctions that the law makes and the GPL ignores. You can't have it
> > both ways. If the module is distributed *with* the kernel *SOURCE* then
> > it doesn't matter if it's a derivative work or not, because it becomes
> > covered by the kernels license.
>
> Yes.
>
> > If it's distributed with the kernel *binaries* then it is
> > covered by its own license. In that case the only reason you'd have a
> > right to the source is if the module is considered a "derivative work".
>
> Not necessarily. I'm not entirely sure where you got that idea from.
>
> If the module is distributed 'as a separate work', _then_ what you say
> is true: the only reason you'd have a right to the source is if the
> module is considered a 'derivative work'.
>
> But when you distribute the same module as part of a whole which is a
> work based on the kernel, the distribution of the whole must be on the
> terms of GPL, whose permissions for other licensees extend to the entire
> whole, and thus to each and every part regardless of who wrote it.

-ELOGIC

> The words you used were 'with the kernel', which could actually mean
> either of the above. In the case of embedded Linux-based firmware
> though, it's definitely the latter. It's a coherent whole, and it
> contains both the kernel and the module. Thus the GPL extends to each
> and every part, regardless of who wrote it. Including the module.

Just because two things are bundled together doesn't put them under the same 
license or copyright. Take a look at the GPL, which specifically mentions 
that "mere aggregation" does not cause something to fall under the GPL. Not 
that the GPL can even change the law - in the US copyright law specifically 
states that "mechanical translation" and "mechanical processes" *CANNOT* 
create a "new" work. Since the process of compiling source into a binary is, 
by definition, a *mechanical* process then the binary can't suddenly become 
covered by a different copyright license than the source code merely because 
of the medium on which its distributed or the manner in which it is 
distributed.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
