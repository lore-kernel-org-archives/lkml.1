Return-Path: <linux-kernel-owner+w=401wt.eu-S1423361AbXD3PZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423361AbXD3PZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423359AbXD3PZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:25:42 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:29758 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423361AbXD3PY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:24:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=s8U4rbOLg/fE6reeE5tpZQAAc8Yt5psu/IWjHnbs/E1gcZz7zmul9Nn7lxMcrWZWrjy5Yh4E6PNewwmwMYVh+s/+M59bIDG96AeerH1PlVth++PkTAWq+eroCP2vYG56/PhKSkdmx1MvDjiJp8Z7l0ruXWiFqlEzcvsW/ApRX1c=
Message-ID: <d9def9db0704300824n6aba254bye2cf4b4eeda2fdac@mail.gmail.com>
Date: Mon, 30 Apr 2007 17:24:58 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Helge Hafting" <helge.hafting@aitel.hist.no>
Subject: Re: [linux-dvb] Re: Critical points about kernel 2.6.21 and pseudo-authorities
Cc: "Uwe Bugla" <uwe.bugla@gmx.de>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       mchehab@infradead.org
In-Reply-To: <4636058B.3070603@aitel.hist.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070429182209.267430@gmx.net>
	 <alpine.LFD.0.98.0704291147530.9964@woody.linux-foundation.org>
	 <20070429205925.129920@gmx.net>
	 <alpine.LFD.0.98.0704291412500.9964@woody.linux-foundation.org>
	 <20070429230037.95120@gmx.net>
	 <1177894713.3046.5.camel@pc06.localdom.local>
	 <20070430110255.267000@gmx.net> <4635D139.4030609@aitel.hist.no>
	 <20070430115000.194060@gmx.net> <4636058B.3070603@aitel.hist.no>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

all these discussions are about Makefile and documentation changes as
far as I see.
I don't see the point why there's a need for such a big discussion
here just about these changes.
Uwe please resend your patch files and lets get this story done, if
your work breaks something we can point you out to what is wrong.
We have what's in the repository now and it won't change unless we put
some time in it again.

Uwe, if you have a problem with anyone here keep it for yourself just
submit the latest patches and I'll have a look asap at it. There's no
need to be unfriendly here.

Markus

On 4/30/07, Helge Hafting <helge.hafting@aitel.hist.no> wrote:
> Uwe Bugla wrote:
> > -------- Original-Nachricht --------
> > Datum: Mon, 30 Apr 2007 13:21:29 +0200
> > Von: Helge Hafting <helge.hafting@aitel.hist.no>
> > An: Uwe Bugla <uwe.bugla@gmx.de>
> > CC: linux-kernel@vger.kernel.org
> > Betreff: Re: [linux-dvb] Re: Critical points about kernel 2.6.21
> and	pseudo-authorities
> >
> >
> >> Uwe Bugla wrote:
> >>
> >>> In this ten Emails you will yourself see the intellectual and technical
> >>>
> >> proof in how far Mr. Chehab is acting with nothing else but:
> >>
> >>> a. Lies
> >>> b. Unproven thesis
> >>> c. Stigmatizations
> >>>
> >>> and so on.
> >>>
> >>> THIS MAN HAS NO IDEA, BUT HE HAS THE POWER!
> >>>
> >>>
> >> Please note that there are ways to replace a bad maintainer.
> >> We still try to keep it polite.
> >>
> >> But note that you can't have someone "fired", no matter how bad they
> >> do their job.  A bad maintainer is usually better than none - the bad
> >> maintainer might improve. Or at least get some simple stuff done.
> >>
> >> You therefore replace a bad maintainer by taking over the position.
> >> Contact whoever is above the maintainer (Linus or some other
> >> higher-level maintainer). You explain the problem, and you must also
> >> show that you have the time and knowledge to do a better job.
> >>
> >
> > Hi Helge,
> > A. I do neither have enough skills to take up a maintainers role
> >
> Then your only hope is to find someone else that is interested.
> > B. Linus and Andrew are high-leveled informed about the whole structural
> problem, but they close their eyes, they simply do not want to see the
> necessity of a replacement.
> > That is at least my impression.
> >
> The aren't doing any less than you do. They don't provide a better
> maintainer, but neither do you.   Linus and  Andrew don't have that
> much more resources than you have.  They have programming skills
> and lots of trust in the community.
>
> >> You can, for example, maintain the same subsystem in parallel.  After a
> >> while,
> >> all interested parties sees that your tree works better and that
> >> communicating with you is easier.
> >> If you aren't prepared to do this - then you have to live with the
> current
> >> maintainer.  There is no staff ready to replace maintainers after
> >> complaints, a volunteer doing a better job is always necessary.
> >>
> >
> > Neither nor: I do not livbe with persons like Chehab and others, no matter
> what the consequence is. To be truthful I would strategically prefare a
> vacuum at the price that the work isn't even done for months.
> > ONLY IF there is a personnel vacuum the necessity for others to volunteer
> will arise.
> >
> A sufficiently bad maintainer will also do it.  If lots of submitters send
> their patches to andrew in order to get past a dysfunctional maintainer,
> then the subsystem effectively is unmaintained.
> > So if you want a real change you gotta first kick the reactionary dumb
> bastards off from their seats without any return ticket - without that there
> won't be any changes at all!
> >
> Well then - create a patch to the MAINTAINERS file that removes this
> maintainer
> leaving the position open.  Perhaps you can get that accepted despite the
> existing maintainer - *if* you can get most other developers for that
> subsystem to add signed-off lines.  It will then be clear that the
> community agrees with you.
>
> However, if the bulk of them thinks the current maintainer is fine, then
> it stays that way.  Satisfying everybody is unfortunately not always
> possible.
> You can always try submitting your own patches above this maintainer.
> > But the practice now is the typical "Sit out and do not react at all"
> behaviour as far as Chehab himself is concerned - Germans remember that
> reactionary gesture from the time when Hellmut Kohl was chancellor for 16
> horrible years.....
> >
> > So there will be no "soft" or "polite" solution at all, but only a harsh
> and rude one:
> > "Kick out the Jams!"
> Dropping lazy or incompetent maintainers do happen occationally.
> But don't let frustration lead to angry emails - all you get that way is
> lost
> credibility, that will only make it harder to convince people.
>
> Helge Hafting
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Markus Rechberger
