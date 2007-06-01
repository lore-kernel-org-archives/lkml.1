Return-Path: <linux-kernel-owner+w=401wt.eu-S1760587AbXFANcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760587AbXFANcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 09:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757184AbXFANcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 09:32:43 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:49796 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757066AbXFANcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 09:32:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=m56Oa6yIODTq7yrLYR7ZDSewRjeqO/uFwO4CaPFPo3h5ptyArs2x23bm08UcpHd30eUmnxuTgrqhgah8LnKCU6rsKddaJKC+1nEfjzOfQtjpCPc6tNbNA6f9UIz5Op62lc4akJyHUfkHVNmuGz1JvG3lzOXKVpqQlGC8pUVRrqU=
Message-ID: <d9def9db0706010632n2efd3de3iff31eef3b3344e3b@mail.gmail.com>
Date: Fri, 1 Jun 2007 15:32:40 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Bill Eldridge" <dcbill@volny.cz>
Subject: Re: [linux-dvb] dst customization patchset
Cc: "Uwe Bugla" <uwe.bugla@gmx.de>, akpm@linux-foundation.org,
       linux-dvb@linuxtv.org, linux-kernel@vger.kernel.org
In-Reply-To: <465FCBD5.3040908@volny.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070530211826.276640@gmx.net>
	 <e0b07cc80705301808j697b816bibbbc0ed5742a69b8@mail.gmail.com>
	 <465E56AB.1000905@volny.cz> <200705311541.41710.uwe.bugla@gmx.de>
	 <d9def9db0705311503i3531b775p9cc226b81a547499@mail.gmail.com>
	 <465FCBD5.3040908@volny.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/1/07, Bill Eldridge <dcbill@volny.cz> wrote:
>
> Sounds good, Markus - do you have a list of known bugs that need to be
> handled?

Yes, I put together a few things that came into mind:
http://mcentral.de/wiki/index.php/Bugtracker

> Is this something that can go up on the Wiki, or are there enough that a
> bug tracking
> system is required?
>

Wiki/ML should be fine, people use to avoid the bugzilla on kernel.org
although I'd be fine with it (at least for the em28xx project) but
people prefer to add bugreports to the wiki or send mails.

> While timelines won't be enforceable for people doing things in their
> spare time, it's
> still useful to put up time goals and priority lists on projects, both
> new development and
> bug fixes, to keep momentum going and gauge progress, including seeing
> that something
> that should have been fixed isn't getting handled.
>
> Can people accept Markus as a reasonable, informed arbiter of what will
> go into the main tree
> even if there are disagreements? It also sounds like new programmers
> here  need more startup
> instructions/assistance/advice and ground rules than on many open source
> projects.
>

I would appreciate to get more people involved with that project,
VDR/mythTV/mplayer/ffmpeg etc. projects use the outcoming work.
While the v4l and dvb project is doing really hard at the moment and
improvements are handled in a snail speed (if ever handled) this
should really change.

cheers,
Markus

> Regards,
> Bill
>
> Markus Rechberger wrote:
> >
> > Some developers are also sick of contributing since the whole
> > community is flawed at the moment. I propose a few ways to go
> >
> > * stopping that signed off by madness that every driver developer has
> > to sign off changes which happened at the core which will definitelly
> > never happen because people _do not like each other_.
> >
> > * change the maintainership and push it over to me, even if it sounds
> > selfish at the moment _every_ code which provides additional features
> > and where noone expects further improvements within the next few weeks
> > (without throwing away alot of work or generating useless extra work
> > by telling someone to rewrite the core of his work); everyone still
> > can try to write better code - but then he _has to do it completly_
> > and get in peace with the projects by supporting them to get further.
> >
> > The problem I have with this project is that many more things are
> > upcoming at the moment (including bug fixing) but there are certain
> > developers which first weren't experienced enough, afterwards started
> > to think about the issues which were tried to discuss at the beginning
> > already and who don't have an overview about the requirements, neither
> > do they want to discuss the requirements.
> > I can name numerous of bugs of this project which can be solved but
> > which just get ignored. Some known bugs dont even get explained to
> > people who are interested in fixing them, so this is what I consider
> > that it's a major problem.
> >
> > I'm looking for a serious discussion about it, if anyone wants to know
> > about the history I can point out to many logfiles/older emails which
> > deeply explain the whole video4linux/dvb issues - the project should
> > turn back to a real community.
> >
> > Markus
> >
>
>
>
>


-- 
Markus Rechberger
