Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbXFNUP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbXFNUP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 16:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbXFNUPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 16:15:17 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:55153 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbXFNUPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 16:15:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qKTI7IzBbsbLyaezs+KFtg//DhaKuFuIMawNZz9dLJjMaVuNooU6dfdHO3g4A0UuRmLEbgQbSwKlSfB3ZjlqFjfEhOqLNji6vHJfpgd0EPEPoB31oJMMl2pDzkBaMHACGhIf13qvti3GCH/yQIKpJ33oy1v6yZ3FbnEv9SwguAg=
Message-ID: <d120d5000706141315p68e6ae00qb7bfb194e9161b90@mail.gmail.com>
Date: Thu, 14 Jun 2007 16:15:14 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Alexandre Oliva" <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Cc: "Daniel Hazelton" <dhazelton@enter.net>,
       "Bongani Hlope" <bhlope@mweb.co.za>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>,
       "Greg KH" <greg@kroah.com>, "debian developer" <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, "Tarkan Erimer" <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>, mingo@elte.hu
In-Reply-To: <ork5u6b8zz.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
	 <200706132108.50030.dhazelton@enter.net>
	 <orlkenjnxm.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <200706140125.24815.dtor@insightbb.com>
	 <orps3zghgo.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <d120d5000706140856s5fdb29c6j1b53cafc291f8ec1@mail.gmail.com>
	 <orodjie7gs.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <d120d5000706141200r744d7cdfv3bfbbf558a05248e@mail.gmail.com>
	 <ork5u6b8zz.fsf@oliva.athome.lsd.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/14/07, Alexandre Oliva <aoliva@redhat.com> wrote:
> On Jun 14, 2007, "Dmitry Torokhov" <dmitry.torokhov@gmail.com> wrote:
>
> > Ok, consider non-derived work.
>
> I did, you snipped it out:
>
> >> If your change is not a derived work, you're not bound by the terms
> >> of the GPL as far as the change is concerned, so the GPL has no say
> >> whatsoever as to how you must release it.  If you choose the GPL,
> >> then you're a licensor, and the requirements to pass on all the
> >> rights you have do not apply.
>

Yes, I did, thank you for putting the text back in.

> > Because I am distributing whole program
> > I have to do it under GPL.

Please notice this sentence. GPL still influences the way I release
stuff (if I want to release the work as whole) but it does not mean
passing all rigths I could possibly have.

> > However I still have the right to
> > distribute just the portion that is written by me under whatevel
> > license I want but you as a recepient of GPLed whole do not get this
> > right. IOW I am not passing all the rights _I have_.
>
> I see what you mean.  IANAL, but I don't think that's how it works.
>
> When your work is not a derived work, the GPL that applies to the rest
> of the program does not make you a licensee, and it only covers your
> work if you choose to license it that way.  And then, you're the sole
> licensor of that piece of the work.

So, with regard to TIVO, why are you saying that GPL shoudl affect
their hardware (I assume that key check/enforce is done in firmware
taht is separate from kernel image)?

-- 
Dmitry
