Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563AbXFMXMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbXFMXMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 19:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbXFMXMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 19:12:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754533AbXFMXMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 19:12:15 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david\@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>
	<18026.16739.228277.938421@notabene.brown>
	<20070609071231.GL2649@lug-owl.de> <466BB9B0.5030908@netone.net.tr>
	<Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
	<466BCBBC.90305@netone.net.tr>
	<Pine.LNX.4.64.0706100301520.6675@asgard.lang.hm>
	<f24d23310706100355j3af7e12fq2e0e345402e48ca2@mail.gmail.com>
	<20070610160531.GA12179@kroah.com>
	<f24d23310706121107y2ef218a4wc1c8f9a52fc9bdd7@mail.gmail.com>
	<20070612184110.GB7980@kroah.com>
	<orir9smp3u.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706131223051.14121@woody.linux-foundation.org>
	<or7iq7mx7f.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706131415090.14121@woody.linux-foundation.org>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Wed, 13 Jun 2007 20:11:33 -0300
In-Reply-To: <alpine.LFD.0.98.0706131415090.14121@woody.linux-foundation.org> (Linus Torvalds's message of "Wed\, 13 Jun 2007 14\:33\:07 -0700 \(PDT\)")
Message-ID: <orir9rlaai.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 13, 2007, Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, 13 Jun 2007, Alexandre Oliva wrote:
>> 
>> Look, there was room for misunderstandings in earlier drafts of the
>> license.  Based on the public comments, the wording was improved.  I'd
>> like to think the issues that arose from misunderstandings of the
>> earlier drafts are no longer an issue.  Is it not so?

> No. The anti-DRM language is still there, and no, it was never a 
> misunderstanding.

It was claimed that GPLv3 would forbid implementations of DRM.  That's
just plain false.  If you don't think so, please show what terms in
the latest draft prohibit DRM (as opposed to merely making it
ineffective, a necessary consequence of abiding by the spirit of all
GNU GPLs)

> It's offensive because Tivo never did anything wrong, and the FSF
> even acknowledged that.

Another misunderstanding.  The FSF never said TiVo didn't do anything
wrong.  It only said it didn't think there was a license violation.  I
personally disagree with that assessment, but IANAL.

Anyhow, deciding whether it's right or wrong is not the same as
deciding whether it's legal or illegal.  Law doesn't define what's
right or wrong.  That's what morals and ethics do.

> want to protect the integrity of that hardware.

> The kernel license covers the *kernel*.

When they choose to include a copy of the kernel in their hardware
that they can modify but others can't, they're failing to comply with
the spirit of the license.  For brevity, I won't repeat the quotes
from the GPLv2 preamble, that I just included in the message I sent to
Lennart Sorensen in this same thread.  Can you justify how you came to
the conclusion (if you did) that TiVo is abiding by the spirit of the
license?

>> Keeping on making false claims about the license drafts can be one of
>> two things: misunderstandings, out of ambiguity in the text or
>> preconceptions, or ill intentions.  I'd rather believe it's the
>> former.

> No, it was not the former.

Wow, I didn't see that coming.  Public admission of ill intentions?
;-) :-D :-P

> And I think the whole "the kernel developers misunderstand the
> license" crap that the FSF was saying (several times) was very
> trying to confuse the issue: the FSF knew damn well which part of
> the license was obnoxious, they just tried to confuse the issue by
> pointing to *another* part of the license.

Let me see if I got this right.  There was a section entitled
"3. Digital Restrictions Management" in GPLv3dd1.  Are you saying
that, when people complained about the DRM clause, they actually meant
the provisions in "1. Source Code", that established a requirement to
include the source code corresponding to functional signatures, namely
the signing keys, as part of the corresponding source code?

> And you're just parrotting their idiotic line.

Please watch your tone.  If you find offense at the allegedly
condescending tone in which the FSF says "misunderstanding", how do
you expect me and the FSF to take this?

It is also odd that you claim the right to be entitled to your own
opinion and reading about stuff, while denying myself the same right.
Please don't do that.  I have a mind of my own, and the fact that I
reach similar conclusions doesn't make me a parrot.  Even more so when
I actually have some influence on those conclusions.

>> Now, of course you can look at the licenses and decide that you never
>> agreed with the spirit of the GPL in the first place, and that GPLv2
>> models better your intentions than GPLv3.

> And this is again the same *disease*. You claim that I "misunderstood" the 
> "spirit of the GPL".

> Dammit, the GPL is a license. I understand it quite well. Probably better 
> than most. The fact that the FSF then noticed that there were *other* 
> things that they wanted to do, and that were *not* covered by the GPLv2, 
> does *not* mean that they can claim that others "misunderstood" the 
> license.

> I understood it perfectly fine, and it fit my needs. So tell me: who is 
> the more confused one: the one who chose the license fifteen years ago, 
> and realized what it means legally, and still stands behind it? I don't 
> think so.

You are definitely confused.  You're talking about the legal terms,
while I'm talking about the spirit.  The legal terms tried to reflect
the spirit as best as they could, but they left some holes.  Some
people found them and started exploiting them.

Sure, if you want to leave those holes unplugged in your code, that's
your decision.  I don't doubt that the GPLv2 legal terms fit the bill
for you.  I think GPLv3 would do even better in this regard.  But none
of this is about the spirit of the GPL.  Claiming GPLv3 changes the
spirit is totally missing the point of what the spirit amounts to.
The spirit is described in the preamble, it's not the legal terms.

> The beauty of the GPLv2 is exactly that it's a "tit-for-tat"
> license,

Ok, let's explore this argument.  In what sense is it tit-for-tat?
What is tit-for-tat about it?  What is the payback an author who
releases software under the GPL can legitimately expect to get?

>> In fact, the spirit has always been described in its preamble, and it 
>> didn't change at all: it's all about respecting others' freedoms.

> That's a lot of bullshit. You are apparently the grand poobah, and can 
> decide _which_ freedoms and for _what_ others' that matter.

The freedoms I'm talking about are very clearly described in the
spirit (preamble) of the license you chose for your project.  Go look
at the preamble one more time, "grand poobah" ;-)

  [...] the GNU General Public License is intended to guarantee your
  freedom to share and change free software--to make sure the software
  is free for all its users [...]

  [...] Our General Public Licenses are designed to make sure that you
  have the freedom to distribute copies of free software (and charge
  for this service if you wish), that you receive source code or can
  get it if you want it, that you can change the software or use
  pieces of it in new free programs; and that you know you can do
  these things.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
