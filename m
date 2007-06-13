Return-Path: <linux-kernel-owner+w=401wt.eu-S1757899AbXFMLBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899AbXFMLBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 07:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756858AbXFMLBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 07:01:44 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:39543
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756619AbXFMLBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 07:01:43 -0400
Date: Wed, 13 Jun 2007 13:02:59 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexandre Oliva <aoliva@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Tarkan Erimer <tarkan@netone.net.tr>,
       debian developer <debiandev@gmail.com>, "david@lang.hm" <david@lang.hm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070613110258.GC15310@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Alexandre Oliva <aoliva@redhat.com>, Ingo Molnar <mingo@elte.hu>,
	Tarkan Erimer <tarkan@netone.net.tr>,
	debian developer <debiandev@gmail.com>,
	"david@lang.hm" <david@lang.hm>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
References: <466BCBBC.90305@netone.net.tr> <Pine.LNX.4.64.0706100301520.6675@asgard.lang.hm> <f24d23310706100355j3af7e12fq2e0e345402e48ca2@mail.gmail.com> <466C0901.4000405@netone.net.tr> <alpine.LFD.0.98.0706101025330.20321@woody.linux-foundation.org> <alpine.LFD.0.98.0706101029300.20321@woody.linux-foundation.org> <466D0A12.5030607@netone.net.tr> <20070611090348.GA18894@elte.hu> <orsl8xsmwf.fsf@oliva.athome.lsd.ic.unicamp.br> <alpine.LFD.0.98.0706120818390.14121@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.0.98.0706120818390.14121@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Tue, Jun 12, 2007 at 08:45:46AM -0700 Linus Torvalds ha dit:

> 
> 
> On Tue, 12 Jun 2007, Alexandre Oliva wrote:
> > 
> > Per this reasoning, Sun wouldn't be waiting for GPLv3, and it would
> > have already released the OpenSolaris kernel under GPLv2, would it
> > not? ;-)
> 
> Umm. You are making the fundamental mistake of thinking that Sun is in 
> this to actually further some open-source agenda.
> 
> Here's a cynical prediction (but backed up by past behaviour of Sun):
> 
>  - first off: they may be talking a lot more than they are or ever will
>    be doing. How many announcements about Sun and Linux have you seen over
>    the years? And how much of that has actually happened?
> 
>  - They may like open source, but Linux _has_ hurt them in the 
>    marketplace. A lot.
> 
>    They almost used to own the chip design market, and it took quite a 
>    long time before the big EDA vendors ported to Linux (and x86-64 in 
>    particular). But when they did, their chip design market just basically 
>    disappeared: sparc performance is so horribly bad (especially on a 
>    workstation kind of setup), that to do chip design on them is just 
>    idiotic. Which is not to say that there aren't holdouts, but let's face 
>    it, for a lot of things, Solaris is simply the wrong choice these days.
> 
>    Ergo: they sure as hell don't want to help Linux. Which is fine. 
		 >    Competition is good.
> 
>  - So they want to use Linux resources (_especially_ drivers), but they do 
>    *not* want to give anything back (especially ZFS, which seems to be one 
>    of their very very few bright spots).
> 
>  - Ergo: they'll not be releasing ZFS and the other things that people are 
>    drooling about in a way that lets Linux use them on an equal footing. I 
>    can pretty much guarantee that. They don't like competition on that 
>    level. They'd *much* rather take our drivers and _not_ give anythign 
>    back, or give back the stuff that doesn't matter (like core Solaris: 
>    who are you kidding - Linux code is _better_).
> 
> End result:
> 
>  - they'll talk about it. They not only drool after our drivers, they 
>    drool after all the _people_ who write drivers. They'd love to get 
>    kernel developers from Linux, they see that we have a huge amount of 
>    really talented people. So they want to talk things up, and the more 
>    "open source" they can position themselves, the better.
> 
>  - They may release the uninteresting parts under some fine license. See 
>    the OpenSolaris stuff - instead of being blinded by the code they _did_ 
>    release under an open source license, ask yourself what they did *not* 
>    end up releasing. Ask yourself why the open source parts are not ready 
>    to bootstrap a competitive system, or why they are released under 
>    licenses that Sun can make sure they control.
> 
> So the _last_ thing they want to do is to release the interesting stuff 
> under GPLv2 (quite frankly, I think the only really interesting thing they 
> have is ZFS, and even there, I suspect we'd be better off talking to 
> NetApp, and seeing if they are interested in releasing WAFL for Linux).
> 
> Yes, they finally released Java under GPLv2, and they should be commended 
> for that. But you should also ask yourself why, and why it took so long. 
> Maybe it had something to do with the fact that other Java implementations 
> started being more and more relevant?
> 
> Am I cynical? Yes. Do I expect people to act in their own interests? Hell 
> yes! That's how things are _supposed_ to happen. I'm not at all berating 
> Sun, what I'm trying to do here is to wake people up who seem to be living 
> in some dream-world where Sun wants to help people. 
> 
> So to Sun, a GPLv3-only release would actually let them look good, and 
> still keep Linux from taking their interesting parts, and would allow them 
> to take at least parts of Linux without giving anything back (ahh, the 
> joys of license fragmentation). 
> 
> Of course, they know that. And yes, maybe ZFS is worthwhile enough that 
> I'm willing to go to the effort of trying to relicense the kernel. But 
> quite frankly, I can almost guarantee that Sun won't release ZFS under the 
> GPLv3 even if they release other parts. Because if they did, they'd lose 
> the patent protection.
> 
> And yes, I'm cynical, and yes, I hope I'm wrong. And if I'm wrong, I'll 
> very happily retract anything cynical I said about Sun. They _have_ done 
> great things, and maybe I'm just too pessimistic about all the history 
> I've seen of Sun with open source.
> 
> The _good_ news is that Jonathan Schwartz actually does seem to have made 
> a difference, and I hope to God he is really as serious about 
> open-sourcing things as he says he is. And don't get me wrong: I think a 
> truly open-source GPLv3 Solaris would be a really really _good_ thing, 
> even if it does end up being a one-way street as far as code is
> concerned!

FYI, Jonathan Schwartz' response:

Linus,

First, I'm glad you give credit to Sun for the contributions we've
made to the open source world, and Linux specifically - we take the
commitment seriously. It's why we freed OpenOffice, elements of Gnome,
Mozilla, delivered Java, and a long list of other contributions that
show up in almost every distro. Individuals will always define
communities, but Sun as a company has done its part to grow the market
- for others as much as ourselves.

But I disagree with a few of your points. Did the Linux community hurt
Sun? No, not a bit. It was the companies that leveraged their work. I
draw a very sharp distinction - even if our competition is
conveniently reckless. They like to paint the battle as Sun vs. the
community, and it's not. Companies compete, communities simply
fracture.

And OpenSolaris has come a very long way since you last looked. It and
its community are growing, as a result of more than ZFS (although we
seem to be generating a lot of interest there, not all intentional) -
OpenSolaris scales on any hardware, has built in virtualization, great
web service infrastucture, fault management, diagnosability, and tons
more. Feel free to try for yourself (and yes, we're fixing
installability, no fair knocking us for that.)

Now despite what you suggest, we love where the FSF's GPL3 is
headed. For a variety of mechanical reasons, GPL2 is harder for us
with OpenSolaris - but not impossible, or even out of the
question. This has nothing to do with being afraid of the community
(if it was, we wouldn't be so interested in seeing ZFS everywhere,
including Linux, with full patent indemnity). Why does open sourcing
take so long? Because we're starting from products that exist, in
which a diversity of contributors and licensors/licensees have rights
we have to negotiate. Indulge me when I say It's different than
starting from scratch. I would love to go faster, and we are all doing
everything under our control to accelerate progress. (Remember, we
can't even pick GPL3 yet - it doesn't officially exist.) It's also a
delicate dance to manage this transition while growing a corporation.

But most of all, from where I sit, we should put the swords down -
you're not the enemy for us, we're not the enemy for you. Most of the
world doesn't have access to the internet - that's the enemy to slay,
the divide that separates us. By joining our communities, we can bring
transparency and opportunity to the whole planet. Are we after your
drivers? No more than you're after ZFS or Crossbow or dtrace - it's
not predation, it's prudence. Let's stop wasting time recreating
wheels we both need to roll forward.

I wanted you to hear this from me directly. We want to work together,
we want to join hands and communities - we have no intention of
holding anything back, or pulling patent nonsense. And to prove the
sincerity of the offer, I invite you to my house for dinner. I'll
cook, you bring the wine. A mashup in the truest sense.

Best,
Jonathan

President, Chief Executive Officer,
Sun Microsystems, Inc. 

http://blogs.sun.com/jonathan/entry/one_plus_one_is_fifty

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

    Yo soy como soy y tú eres como eres, construyamos un mundo donde yo
    pueda ser sin dejar de ser yo, donde tú puedas ser sin dejar de ser
    tú, y donde ni yo ni tú obliguemos al otro a ser como yo o como tú
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
