Return-Path: <linux-kernel-owner+w=401wt.eu-S1752640AbXFUXHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbXFUXHQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 19:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750708AbXFUXHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 19:07:05 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:7863 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbXFUXHD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 19:07:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SNk076eSXcNBNJucfk1vYf6jvSH1xfRGtg+g2F5bHMRFJ2NjXXxIOEQlsdncWMnVJOsCJhp9svnUmDcZXPeQZQYqkfK9oCd+w7ZwAb8O3I3w6WwpV3o4JZ+Il+A88G43gS0GjrjICEQ6thHSQxWnWmvQAVII3tisy8EYgUkCTzs=
Message-ID: <9a8748490706211607x4d151842lb4df63be35658f23@mail.gmail.com>
Date: Fri, 22 Jun 2007 01:07:02 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "=?ISO-8859-1?Q?Zolt=E1n_HUBERT?=" <zoltan.hubert@zzaero.com>
Subject: Re: Please release a stable kernel Linux 3.0
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200706220057.33984.zoltan.hubert@zzaero.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <200706212349.54983.zoltan.hubert@zzaero.com>
	 <9a8748490706211529yca0588dgd1f7e0b86f7e4a62@mail.gmail.com>
	 <200706220057.33984.zoltan.hubert@zzaero.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/06/07, Zoltán HUBERT <zoltan.hubert@zzaero.com> wrote:
> On Friday 22 June 2007 00:29, Jesper Juhl wrote:
>
> > > You might think it's easy for me to simply "use" Linux
> > > and complain while you're doing the hard stuff. As it
> > > happens, the current development/stable model makes our
> > > life as "users" more and more difficult.
> >
> > In what way?
>
> Well, I'm using SuSE Pro 9.3 (excellent choice by the way),
> coming with kernel 2.6.10-SuSE, on a ATI laptop, and the
> drivers privided wouldn't compile (suspend & freinds).

Didn't the distribution already come with pre-compiled drivers?

> The
> SATA disks were only supported from 2.6.15 (which just came
> out),

So you installed the distribution on hardware it did not support. How
is that the kernel's problem? Go talk to Novell about that.


>so I had to edit the "source code" of a closed source
> driver to make it all work well. If that's "easy" for you I
> doubt it is for 99.999% of earth's population. "World
> domination" is far away.
>
That's not easy. Agreed. But, that's hardly the kernels problem.
That's your problem for trying to install a distribution on
non-supported hardware. One could also argue that its your problem for
buying hardware without open drivers available.


> Also, the 7 National Instruments cards I'm using for a
> deformable mirror in Adaptive Optics in an industrial PC
> are "certified" for SuSE 9.3 only. Which, this week, got
> discontinued. So what now ?
>
Complain to the vendor of that hardware. Ask them to either continue
supporting the OS you are using or open source the drivers.
How can that ever be anything but an issue between you and your hardware vendor?

> > Most users should be using distribution kernels anyway,
>
> ???? should ???? who do you think "users" are ????
>

Well, you for one claimed you were a user, and I would say almost
anyone who doesn't hack the kernel or wants to test it falls into the
user category.

> > not vanilla kernel.org kernels.
>
> Who said I was using vanilla kernels ?
>
Noone, I made a guess.

> > > "development" branches. And it would certainly help
> > > vendors of closed-source drivers.
>
> > Their choice, their problem.
>
> no, it's MY problem.
>
Indeed. It is your problem. You bought hardware not supported by Open
Source drivers so noone on LKML can help you with that - only vendor
of the closed source driver can help you. To buy that hardware was
your choice, hence it it is your problem, we can agree on that.

> > I don't think you'll find very
> > many people on this list who gives a damn about the
> > troubles of closed source driver developers.
>
> and what about their users ?
>
That's between the vendor and their customers. The vendor made a
choice only to release closed source drivers and the customer made a
choice to purchase hardware only supported by closed source drivers.
That can never be anything but the vendor and customers problem.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
