Return-Path: <linux-kernel-owner+w=401wt.eu-S1758856AbXFQXwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856AbXFQXwf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 19:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbXFQXw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 19:52:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbXFQXw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 19:52:27 -0400
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Al Viro" <viro@ftp.linux.org.uk>,
       "Bernd Schmidt" <bernds_cb1@t-online.de>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Ingo Molnar" <mingo@elte.hu>,
       "Daniel Hazelton" <dhazelton@enter.net>, "Greg KH" <greg@kroah.com>,
       "debian developer" <debiandev@gmail.com>, david@lang.hm,
       "Tarkan Erimer" <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
	<orir9p10xw.fsf@oliva.athome.lsd.ic.unicamp.br>
	<4673CA7C.5040207@t-online.de>
	<orlkejrg4o.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070616181902.GB21478@ftp.linux.org.uk>
	<or1wgbras9.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706161952280.14121@woody.linux-foundation.org>
	<orabuzkw0i.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706171157400.14121@woody.linux-foundation.org>
	<or3b0qgy8r.fsf@oliva.athome.lsd.ic.unicamp.br>
	<9a8748490706171436x6b9f2f13pf115d97fee3b1525@mail.gmail.com>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Sun, 17 Jun 2007 20:51:35 -0300
In-Reply-To: <9a8748490706171436x6b9f2f13pf115d97fee3b1525@mail.gmail.com> (Jesper Juhl's message of "Sun\, 17 Jun 2007 23\:36\:36 +0200")
Message-ID: <ory7iidtrs.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 17, 2007, "Jesper Juhl" <jesper.juhl@gmail.com> wrote:

> On 17/06/07, Alexandre Oliva <aoliva@redhat.com> wrote:
> [snip]

>> Serious, what's so hard to understand about:

>> no tivoization => more users able to tinker their formerly-tivoized
>> computers => more users make useful modifications => more
>> contributions in kind

> I have to disagree.

Your analysis stopped at the downside of prohibiting tivoization.  You
didn't analyze the potential upsides, so you may indeed come to
different conclusions, and they may very well be wrong.

It's very human to look only at the potential downside of an action
and conclude it's a bad action.

But it's more rational to look at the potential upside as well,
evaluate the likelihood of each in the grand scheme of things, and
then decide whether the potential upside will make up for the
potential downside.


> Let's say that for some reason I don't want the end users of my
> device to tinker with the software inside my device.

Ok, keep the *want* in mind.  This is very important.


> Now I think you can agree to these things being positive:

Yes, even if I'd phrase them slightly differently.

> The only downside is that the end user purchasing the device can't
> install modified versions of the software on it.

And therefore you severely limit the number of end users who might
turn into contributors because of self interest in hacking the device
to suit their needs.


> Now let's try it in a GPLv3 universe.  Since I can no longer create my
> device without having to allow the end user to install modified
> software on it

False assumption.  You can create the device using GPLv3 software in
it.  So your acccounting of necessary downsides is only one of the
possibilities.  The other possibility would be to have the program in
ROM, of course, which would come with a completely different set of
downsides, but that would retain all of the "these things being
positive" you mentioned above.


And, remember, since you merely don't *want* the end user of the
device to tinker with the software, you have the option to do let them
do that.

And, if you do, they may find in themselves reasons and incentives to
change the software in the device, and the improvements are likely to
get back to the community and thus back to you.  Everybody wins.

This is the upside that you left out from your analysis, and from
every other analysis that set out to "prove" that anti-tivoization is
bad that I've seen so far.

It appears that people are so concerned about whatever little they
might lose from requiring respect for users' freedoms that they don't
even consider what they might win, and that they *would* win if at
least some of the vendors were to make an choice more favorable to
their users and the community.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
