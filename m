Return-Path: <linux-kernel-owner+w=401wt.eu-S1760693AbXFVTP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760693AbXFVTP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 15:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477AbXFVTPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 15:15:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753769AbXFVTPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 15:15:17 -0400
To: Theodore Tso <tytso@mit.edu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Al Viro <viro@ftp.linux.org.uk>,
       davids@webmaster.com,
       "Linux-Kernel\@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: how about mutual compatibility between Linux's GPLv2 and GPLv3?
References: <MDEHLPKNGKAHNMBLJOLKCEKCEMAC.davids@webmaster.com>
	<or4pl0iz15.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070622013417.GT21478@ftp.linux.org.uk>
	<20070622041949.GA15625@thunk.org>
	<20070622101423.145b0279@the-village.bc.nu>
	<20070622144748.GB15285@thunk.org>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Fri, 22 Jun 2007 16:14:39 -0300
In-Reply-To: <20070622144748.GB15285@thunk.org> (Theodore Tso's message of "Fri\, 22 Jun 2007 10\:47\:48 -0400")
Message-ID: <ory7ibby3k.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 22, 2007, Theodore Tso <tytso@mit.edu> wrote:

> On Fri, Jun 22, 2007 at 10:14:23AM +0100, Alan Cox wrote:
>> > Another law of negotiations --- don't goad people into hardening their
>> > positions; it helps neither you nor your interests.
>> 
>> That always depends which side you really support, whether you want to
>> force someone to wedge themselves in an undefendable corner and so on..

> Well yes, I'm assuming that the goal is successfully concluded
> negotiations.

I guess this means you don't believe what I claimed all the way from
the beginning about what I was trying to accomplish.  Not surprising,
really.

Please believe me.  I know I'm a terrible negotiator.  I know I get
people to harden their positions.

Why on earth would I, knowing about these shortcomings of mine, get
into this debate if my goal were to convince you guys, who'd pretty
much all made up your minds months ago, to change anything?  This
would be utterly stupid.  Do you think I'm *that* stupid?

Not just a terrible negotiator, but also a stupid liar? :-)


I know what I was trying to accomplish.  I can even show evidence of
that, which you may very well disbelieve.  When one of the FSF execs,
worriedly wrote to me after reading about a discussion I was allegedly
having with Linus on behalf of the FSF
http://digg.com/linux_unix/Linus_Torvalds_to_the_FSF_I_m_damn_fed_up,
he asked me what I was trying to achieve.  On the same day, June 14, I
responded that I'd repeatedly made it clear (but apparently never
clear enough) that I didn't speak for the FSF, and not even for FSFLA,
and that what I was trying to achieve was:

  - set the record straight on my opinion as to whether GPLv3 changes
  the spirit of the GPL (it doesn't, not even in the case of
  Tivoization, as argued in
  http://fsfla.org/svnwiki/blogs/lxo/draft/gplv3-snowwhite

  - dispell myths as to other apparent new obligations that people
  seem to perceive in GPLv3, that were either already present in GPLv2
  or that are necessary to better abide by the spirit of the GPL
  encoded in the preamble

  - offer evidence that whatever perceived losses the Linux (kernel)
  community might suffer from switching to GPLv3 would be from
  non-contributors who are not really willing to abide by the spirit
  of the GPL chosen by the Linux authors, and that it would rather be
  more beneficial for Linux because it would push the exploiters away
  while making room for more actual contributors

Now, since I wrote this, I learned that many Linux authors really
understood the "no further restrictions" provision of GPLv2 in a far
more limited different way, that the spirit in which they licensed
their code departed from the spirit of the GPL.  Nevertheless, I
offered the reasoning I had to offer about potential benefits of
anti-tivoization provisions, because I saw no evidence that anything
but potential negative consequences had been taken into account.  The
same negative consequences that are being brought up WRT the GPLv3
clarifications have repeatedly been brought up against the GPL since
its inception: "Oh my God, this will scare businesses, they will never
use it."  Time is showing these fears were largely exaggerated.  I
hope this will prove true for GPLv3 as well, but my crystal ball is
failing me, even more so because a critical piece of code that would
enable us to tell, in the long run, is, let's say, highly skeptical of
the possibility that prohibiting certain uses can be beneficial in the
long run.


As for why I got into this debate...  Isn't it much simpler to believe
that I got into the debate because Greg KH wrote things about GPLv3
that I understand to be incorrect, and I wanted to set the record
straight on it, than that I, an admittedly unskilled negotiator, was
going to try to "push GPLv3 down your throats"?

And that the most important issue to set the record straight on was
*precisely* about the complaint, signed by him and about half of the
major contributors to Linux, and later supported by other major
contributors, that GPLv3 changed the spirit of the license?  How on
earth can you and others possibly claim with a straight face that
"nobody cares about the spirit"?

The other point I intended to make was the accusation that the FSF was
dividing the community.  This is very unfair.  If the release of a
license that more clearly expresses the intent of part of the
community, and this part of the community adopts it, while another
part of the community rejects it, is this not a sign that the
community is already divided?

Given that part of the community at large, including the FSFes, seeks
better defenses for the freedom of their code, seeks respect for the
"freedom or death" provision already present in GPLv2 (even if
interpreted by some in a narrower sense than it was meant), how is it
fair to complain that they exercise the option to obtain such
defenses, on the grounds that the complaining party might no longer
get the full cooperation of the party who wanted more?

If you're unhappy with GPLv3, why couldn't people who want better
assurance that their code won't be used in ways they don't want be
unhappy that GPLv2 doesn't guarantee these defenses for them?

Don't you see that attacks on GPLv3, suggestions that it's weakened or
dropped, such that these two parts of the community could keep on
cooperating under terms you prefer but they don't, would be just as
bad for others as taking GPLv2 away from you would?

GPLv2 is not going away.  GPLv3 is going to be one more option, and
it's better than GPLv2 for many people.  You can have different goals
than GPLv3 and prefer other licenses over it as much as you want.  I
don't care (*).  But please respect that others disagree with your
goals and want GPLv3, and if this reduces the amount of cooperation
you get from them to achieve your goals, realize that you're also
refusing to cooperate with them to achieve theirs.  This is
unfortunate, but it's not unfair.  What's unfair is to try to shift
the blame onto only one of the parties.

(*) I reserve the right to vocally oppose decisions for non-Free
Software licenses, because I understand that, even though anyone may
have a legal right to make such decisions, it's unethical to make such
decisions, and it prolongs a social problem that I devote a
significant portion of my life to terminate.  I thank you all for your
help in achieving this goal, even if it's involuntary.

> it was really *you* who had no interest in reaching a mutually
> agreeable compromise,

This is an unfair characterization of the situation.  I think both
sides have very little interest in compromising their positions, and
that's fair.  Yesterday, when *I* (!= FSF, != FSFLA) started this
thread with a proposal about mutual compatibility that seemed to me to
be a reasonable compromise, that AFAICT would meet all of the points
that had been brought in the long discussion that preceded, was when I
started an effort of mediating a negotiation between two parties that
AFAICT were not really interested in participating in such a
negotiation.

My suggestion wouldn't work unless both parties made some concessions,
in order to obtain the benefits of mutual cooperation.  No party would
be required to make such concessions.

The only thing that's clear so far is that one person in one party is
not interested in using such an agreement; a person that had already
voiced an opinion against relicensing his contributions to Linux in a
GPLv3-compatible way, not even if Sun were to license the OpenSolaris
kernel under GPLv3.  No surprise here.

I wish I'd got other opinions about this proposal, though, such that I
can make a decision on whether it even makes sense for me to champion
this suggestion towards inclusion in GPLv3.

> at times where one could wonder if he was really sent by Tivo to
> make sure the kernel would stay GPLv2.  :-)

:-) Dammit, how did you guess?  :-)  I even tried to disguise it by
insisting that GPLv2 already prohibits this practice!  :-)

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
