Return-Path: <linux-kernel-owner+w=401wt.eu-S1765507AbXFRSnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765507AbXFRSnD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 14:43:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764219AbXFRSmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 14:42:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763316AbXFRSmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 14:42:53 -0400
To: Johannes Stezenbach <js@linuxtv.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, Bernd Schmidt <bernds_cb1@t-online.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Daniel Hazelton <dhazelton@enter.net>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <20070615101007.0cbfd078@the-village.bc.nu>
	<orir9p10xw.fsf@oliva.athome.lsd.ic.unicamp.br>
	<4673CA7C.5040207@t-online.de>
	<orlkejrg4o.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070616181902.GB21478@ftp.linux.org.uk>
	<or1wgbras9.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706161952280.14121@woody.linux-foundation.org>
	<orabuzkw0i.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706171157400.14121@woody.linux-foundation.org>
	<or3b0qgy8r.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070618155016.GA31892@linuxtv.org>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Mon, 18 Jun 2007 15:41:44 -0300
In-Reply-To: <20070618155016.GA31892@linuxtv.org> (Johannes Stezenbach's message of "Mon\, 18 Jun 2007 17\:50\:16 +0200")
Message-ID: <or645lcdg7.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 18, 2007, Johannes Stezenbach <js@linuxtv.org> wrote:

> I think those two goals are somewhat conflicting. If you want to
> win people for free software, you need to make it easy for them
> to accept your ideas. However, in order to make it easy you have to
> make compromises wrt the four freedoms.

If you make compromises, it ceases to be free software.  *And*, in the
pragmatic plane, you lose the benefits from users whose freedoms will
be restricted by others.

> If you look at the lenght of this thread, don't you realize
> that even when you talk to software developers on a mailing list
> dealing with free software/open source, you have trouble
> to get acceptance for your fundamentalistic view of the
> ethical principles of free software?

I do.  I get rejection from a number of people from whom I expected to
get rejection, those with fundamentalist but opposing positions.
Meanwhile, in private, I get lots of voices of encouragement and
gratitude for what I'm doing.  I suppose they might even do that in
public if they didn't care about getting verbal abuse for exposing
dissenting opinions.

> And you haven't even started to talk to the business people,
> executives and lawyers which you need to convince if you
> want to make free software ubiquitous.

Oh, really?  How do you know?

People talk a lot about TiVo here, but do they the faintest idea of
how the conversations with TiVo are proceeding?  I thought so...

> "It's a bargain, you can use it for free and all you have to do is
> give back your changes" is what might work to win them.

And that's precisely what I've been working on.  But fundamentalism
can indeed blind people.  It works both ways, I guess.

> The bottom line is that I think your perception is completely wrong.

Do you think any part of this reasoning is wrong?

>   no tivoization => more users able to tinker their formerly-tivoized
>   computers => more users make useful modifications => more
>   contributions in kind

I know you see the other possibility:

>   no tivoization => fewer contributions from manufacturers that demand
>   on tivoization

and there's another, that's break-even for the community so I didn't
even mention it:

    no tivoization => ROM software, no difference for the community


So, you see, when people who oppose anti-tivoization measure the
outcome for the community, they only look at the second possibility,
assuming the vendor would immediately switch to some other software.
As if that was easy for the vendor, and as if the software sucked so
much that the vendor was just looking for a reason to switch.

But since the software is good, and moving to another software would
be costly in various dimentions, the vendor has an incentive to stick
with the software they have.

So the vendor will look into respecting users' freedoms, and they
might just do that, rather than switching to a tivoizable software or
facing the potential costs of ROM replacements at every software
update.

And if just a few vendors take the stance of respecting users'
freedoms, the community will gain not only more users, but also more
developers more motivated to improve the software to serve their own
interests, because they *will* be able to use the results of their
modifications on their devices.


So you see, the picture of anti-tivozation is not as bleak as people
try to frame it.  In fact, it's not bleak at all.  If one out of 10,
maybe even 1 out of 100 vendors start respecting users' freedoms, when
faced with anti-tivoization provisions, the community will already win
big time, because each vendor is likely to have thousands of
customers, some of which will use the freedoms to serve the goals of
the community, in the very terms the community claims to care about.


So, what flaw do you see in this reasoning?

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
