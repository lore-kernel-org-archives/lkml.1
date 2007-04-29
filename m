Return-Path: <linux-kernel-owner+w=401wt.eu-S1161521AbXD2W5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161521AbXD2W5E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 18:57:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161529AbXD2W5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 18:57:04 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:38307 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161521AbXD2W5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 18:57:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Zt+tMh05DC6TxFrVC5Qj9NNTY9e1YjKrX1qpAupsTyA7QBmN+c9hBO7bo4RyP0P2ZMoHHRFPYgjzMp+vmfMD91pozNOaOAIftEw9kNgYBVlOjq753a421khrtrMxQLmzM/go824PGT4arIcLnZB5hZ3e3nVLkpUBUOM9BbigIAo=
Message-ID: <6bffcb0e0704291557l23f08d9as44ed55805c3fec18@mail.gmail.com>
Date: Mon, 30 Apr 2007 00:57:00 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: Linux 2.6.21
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Diego Calleja" <diegocg@gmail.com>, "Andi Kleen" <andi@firstfloor.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070429224256.GA23336@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070429180909.GA30604@one.firstfloor.org>
	 <20070429201729.GQ3468@stusta.de>
	 <20070429225657.a501ab5a.diegocg@gmail.com>
	 <20070429211028.GT3468@stusta.de>
	 <6bffcb0e0704291416u402668ffo9bcaafb389228981@mail.gmail.com>
	 <20070429212128.GU3468@stusta.de>
	 <1177883521.5791.156.camel@localhost.localdomain>
	 <20070429221958.GX3468@stusta.de>
	 <1177886010.5791.166.camel@localhost.localdomain>
	 <20070429224256.GA23336@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/04/07, Adrian Bunk <bunk@stusta.de> wrote:
> On Mon, Apr 30, 2007 at 12:33:30AM +0200, Thomas Gleixner wrote:
> > On Mon, 2007-04-30 at 00:19 +0200, Adrian Bunk wrote:
> >...
> > > And it failed because many regressions still stayed unfixed and some
> > > even undebugged.
> >
> > No it failed not. It is not perfect. Way more bugs, which have been
> > fixed or are in the debugging process, would have been unnoticed and
> > ignored otherwise.
> >...
>
> It depends on what you consider failure and what you consider success.

I hope that this discussion about bugs will change something in Linux
regressions front.

Huge thanks to you for that.

>
> For me, it failed. Not because it wasn't perfect, but because we could
> have done much better with fixing the known regressions, and also by not
> introducing several regressions between the last -rc and the final
> kernel (and people who did test -rc7 and would most likely also have
> tested an -rc8 ran into them).
>
> >       tglx
>
> cu
> Adrian

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
