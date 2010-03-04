Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581Ab0CDXOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 18:14:19 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:49190 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab0CDXOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 18:14:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Gq6x1Jr1CzjRCub1ExSwyfEPOBhlmYhtd1P/Hc0hQsX4RO8eb1iz06lGawZh6BRGd/
         wXWMN13jsYSzDYd/rjFOHJc9CqeqsbJmoTIlwuqar9CebJ/MZKIVz5W85NoO+U8SVsGn
         G9YvRyn2raF6z1E4RYnH7tWqaVGL9cXmyuJt4=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1003041458140.3751@localhost.localdomain>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>
	 <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain>
	 <alpine.LFD.2.00.1003041035380.3751@localhost.localdomain>
	 <20100304185002.GA23532@srcf.ucam.org>
	 <alpine.LFD.2.00.1003041051470.3751@localhost.localdomain>
	 <20100304190450.GA23807@srcf.ucam.org>
	 <alpine.LFD.2.00.1003041110070.3751@localhost.localdomain>
	 <1267741697.1316.16.camel@atropine.boston.devel.redhat.com>
	 <alpine.LFD.2.00.1003041458140.3751@localhost.localdomain>
Date: Thu, 4 Mar 2010 15:14:15 -0800
Message-ID: <6a89f9d51003041514j2ed1eb5csa1b01862babce7a2@mail.gmail.com>
Subject: Re: [git pull] drm request 3
From: Stephane Marchesin <stephane.marchesin@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adam Jackson <ajax@redhat.com>, Dave Airlie <airlied@linux.ie>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 4, 2010 at 15:03, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Thu, 4 Mar 2010, Adam Jackson wrote:
>
>> On Thu, 2010-03-04 at 11:14 -0800, Linus Torvalds wrote:
>> > On Thu, 4 Mar 2010, Matthew Garrett wrote:
>> > > If you'd made it clear that you wanted the interface to be stable
>> > > before it got merged, I suspect that it simply wouldn't have been merged
>> > > until the interface was stable.
>> >
>> > What kind of excuse is that? It's "we did bad things, but if we didn't do
>> > those bad things, we'd have done _other_ bad things"?
>> >
>> > Two wrong choices don't make a right.
>>
>> So unmerge it.
>
> That's what I told people I can do (I'd just revert that commit).
>
> I can do that. But it's not very productive, is it? What about the people
> who _do_ want to run the rawhide tree?
>
> Seriously - what's wrong with my suggestion to just version things
> properly? What's wrong with _fixing_ a stupid technical problem? What's
> wrong with people that you can't see that there are actual _solutions_ to
> the f*cking mess that is the current situation?
>
> I can solve it for my own use, and I already stated so. But while kernel
> developers should be scratching their own itches, a kernel developer that
> can't see past his own small sandbox is pretty damn worthless. We do need
> to fix this - and I'm bringing it up and complaining about it, because the
> nouveau people have _not_ done anything remotely sane.
>

Again, if we thought the DRM interfaces were good to begin with, we'd
have submitted the driver for inclusion. But that's not the case so
the we didn't submit the DRM. Whoever did gets to cope with the
issues.

Good luck,
Stephane
