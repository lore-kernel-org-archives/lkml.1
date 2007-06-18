Return-Path: <linux-kernel-owner+w=401wt.eu-S932790AbXFRVdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932790AbXFRVdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 17:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763205AbXFRVdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 17:33:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762608AbXFRVdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 17:33:12 -0400
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Chris Friesen <cfriesen@nortel.com>,
       Bernd Schmidt <bernds_cb1@t-online.de>,
       Robin Getz <rgetz@blackfin.uclinux.org>, Rob Landley <rob@landley.net>,
       Bron Gondwana <brong@fastmail.fm>, Al Viro <viro@ftp.linux.org.uk>
Subject: Re: mea culpa on the meaning of Tivoization
References: <orzm329s9k.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706172115.20285.dhazelton@enter.net>
	<orsl8paxl0.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706181559.40320.dhazelton@enter.net>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Mon, 18 Jun 2007 18:31:47 -0300
In-Reply-To: <200706181559.40320.dhazelton@enter.net> (Daniel Hazelton's message of "Mon\, 18 Jun 2007 15\:59\:39 -0400")
Message-ID: <orps3t9cfw.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 18, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:

> On Monday 18 June 2007 15:09:47 Alexandre Oliva wrote:

>> Yes.  Anyone feels like enforcing the GPLv2 in Brazil?

> I don't know if I have the right. None of the code is mine

It would have to be some major copyright holder of core Linux code, or
the mips port (IIRC it's mips hardware), or some other driver they're
using.

> Okay. So its possible to change whats running on the hardware - but
> even though nobody has the information needed to do it, it's a
> violation.  Hrm... I can see some valid reasoning behind this,

Yup.  Same reasoning as "I threw the source code away", really.

> "Effectively" - yes, that is the perfect way to describe it. And
> even though it isn't directly part, a situation like that should be
> covered.

And if you look at GPLv3dd1 or dd2 IIRC, that's how it started.  For
some reason, the FSF turned it into the more lax (in some senses)
installation information for user products in dd3.  Maybe they decided
that the argument about the signature being effectively part of the
executable, and therefore the key being effectively part of the source
code, was less likely to be upheld in a court of law than this
alternate phrasing.  All in all, the effect is the same AFAICT, and
the spirit is being complied with.

>> > What the GPLv3 has done is take away options they might otherwise
>> > have had.

>> It doesn't.  Authors can always grant these options separately if they
>> want to.  Authors can always choose GPLv2 if they want to.

> Okay. I think that someone pointed out a problem with the "optional grant" 
> idea, but I can't remember the specifics and don't feel like digging through 
> the 500 or so posts that make up this discussion.

Linus claimed he would then have to refrain from accepting
contributions from anyone who removed this additional permission.

I don't see how this is different from refraining from accepting
contributions under any other license, except that you can't use
license incompatibility to reason it out as an impossibility you
established for yourself in just the very same way.

>> > If one of the goals of the FSF is to force proprietary software into
>> > a minority then its just done damage to that goal.

>> That's not the goal.

> I didn't say it was "the goal", I said "one of the goals".

I stand corrected.  Sorry.  It's been a long thread and a long week.

My objection was mainly about the "forcing".  FSF's stance is about
educating users as to the moral and ethical reasons, such that they
reject non-Free Software, while at the same time providing software
authors with means to stop others from hurting users, by depriving
them of the freedoms they're morally entitled to have.

Others often perceive FSF's tactics as forceful, and I don't deny that
this may be justified, based on past interactions with the FSF.  That
said, I think they've improved a lot, even if they're not perfect (who
is?).  But the perception and the consequent rejection unfortunately
remains as strong as ever.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
