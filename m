Return-Path: <linux-kernel-owner+w=401wt.eu-S1031595AbXEAJAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031595AbXEAJAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 05:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031601AbXEAJAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 05:00:47 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:27063 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031595AbXEAJAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 05:00:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PV21kWjxs57VxF1O7IJTDqVn3Yb0QhvVGJClSSaDFppgGgjJ9WRb1mpB4I/36N54Eg5vC1LL2CadqYNcT3jUc0RZYMoA555yy2UjGOYhKxlH+QAVj+yMtZ3ISZybzitV7RC5Btq2e5jklzFNEAc3gzP9bARmT6ctB3kKSc2b7N8=
Message-ID: <d9def9db0705010200n4e09f4aega7e54bca06a029e3@mail.gmail.com>
Date: Tue, 1 May 2007 11:00:44 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Simon Arlott" <simon@fire.lp0.eu>
Subject: Re: [linux-dvb] DST/BT878 module customization (.. was: Critical points about ...)
Cc: "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Manu Abraham" <abraham.manu@gmail.com>, linux-dvb@linuxtv.org,
       linux-kernel@vger.kernel.org, helge.hafting@aitel.hist.no,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
In-Reply-To: <4636E0E2.5020601@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9def9db0704301417i214a17a8i1fdcbc69f837669@mail.gmail.com>
	 <4636E0E2.5020601@simon.arlott.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/1/07, Simon Arlott <simon@fire.lp0.eu> wrote:
> On 30/04/07 22:17, Markus Rechberger wrote:
> > Trent Piepho wrote another patch for it, it just completes Uwe's patch
> > in the end.
> > From my side I do not see any problem with that patch, if someone else
> > has a problem with it please state out the reason.
>
> I have no problem with the patch since it has nothing to do with my DVB
> card but you're only encouraging Uwe to be abusive since it seems to
> help get him what he wants:
>
> On 01/05/07 00:05, Uwe Bugla wrote:
> > Piepho, you are a devil, and your links do not work at all!
> > Uwe
>
> On 01/05/07 00:40, Uwe Bugla wrote:
> > Go to hell, Manuel Abraham, and do not return at all to absolutely no
> thinkable condition at all, and never come back to this place once more
> again
> > Just goto hell, you goddamn deeply asocial miserable sonofabitch!!
> >
> > Uwe
>
> > On 4/30/07, Markus Rechberger <mrechberger@gmail.com> wrote:
> >> it's enough, I told him that I'll look at it and try to get some other
> >> people involved if it really breaks something it should get stated
> >> out; and I'll refuse any further help if he starts to write any more
> >> abusive mail.
>
> It's not working. Patches should still be applied on the basis of what
> they do and how, not why they were made, of course.

this patch was written by Trent, and it seems like he already had that
idea earlier too.

I really don't care if that patch goes in or not in the end, there's
just no need to flame around for it.

The only reason I see is that it's not needed to link it statically
against the bt878 module and there isn't even much work to do.
Uwe's Makefile patch worked as expected, but it wasn't clean/complete
enough that was a reason to not include it.
Now with Trent's patch I don't see that as a valid argument against it anymore.
And the email from Manu claiming that it generates alot work (which is
btw. 2 years old) doesn't seem to be valid either.

Markus
