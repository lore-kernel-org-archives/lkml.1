Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbXFUXET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbXFUXET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 19:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbXFUXEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 19:04:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44385 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbXFUXEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 19:04:07 -0400
Date: Fri, 22 Jun 2007 00:04:05 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Alexandre Oliva <aoliva@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: how about mutual compatibility between Linux's GPLv2 and GPLv3?
Message-ID: <20070621230404.GS21478@ftp.linux.org.uk>
References: <orlkedpryc.fsf@oliva.athome.lsd.ic.unicamp.br> <20070621180029.GR21478@ftp.linux.org.uk> <orhcp1jc8o.fsf@oliva.athome.lsd.ic.unicamp.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <orhcp1jc8o.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2007 at 05:15:03PM -0300, Alexandre Oliva wrote:
> On Jun 21, 2007, Al Viro <viro@ftp.linux.org.uk> wrote:
> 
> > On Thu, Jun 21, 2007 at 06:39:07AM -0300, Alexandre Oliva wrote:
> 
> >> - the kernel Linux could use code from GPLv3 projects
> 
> > ... and inherit GPLv3 additional restrictions.  No.
> 
> Respecting the wishes of the author of that code.  Are you suggesting
> they should not be respected?

Do piss off.  You know full well what I'm saying.
 
> Anyone who's not happy about it can still take that portion out,
> unless you accept changes that make this nearly impossible, which I
> suppose you wouldn't given how strongly you feel about this.

Oh, right.  "Anyone who doesn't like proprietary code in the tree
can just remove it, what's the big deal?" analog.  Sorry, doesn't work.

> Without this provision, you wouldn't be able to use the code in the
> first place, so I don't perceive any loss for anyone.  Do you?

Replace GPLv3 with proprietary in your argument and look in archives.
That had come up quite a few time in such form.

> >> - GPLv3 projects could use code from Linux
> 
> > Oh, rapture!  How could one object against such a glorious outcome?
> 
> Exactly ;-)

Look up "sarcasm".
> 
> Two-way cooperation.  I'm told that's good.  I was told this was even
> desirable.

Again, replace v3 with proprietary and reread your argument.

> I can see that one-way cooperation could be perceived as unfair, even
> if permissions granted by GPLv3 are all granted by GPLv2 as well.

... but not the other way round.  So in effect we get a change of kernel
license, GPLv3 people *do* *not* get any license changes on their projects.
And you are saying that it's not one-way?

> > ... except for that pesky "no added restrictions" part, but hey, who
> > cares?
> 
> But see, nobody would be adding restrictions to *your* code.

Liar.  I'm sorry, but I do _not_ believe that you are honestly clueless
about GPL to that extent, especially given your claims of participation
of v3 development.  What you are saying is "but your code will be still
available under GPLv2".  Yes, it will.  So it will be if e.g. SCO pulls
it into proprietary codebase.  And you know damn well that this _is_
against the intentions of the license.  Besides, changes to code should
be available under the same license.  The first change in v3 project
affecting both imported v2 code and native v3 one will create a big problem.

> > ... because it's For The Benefit Of User Freedoms!!!
> 
> It is either way.  Do you deny that tivoization also benefits one
> user/licensee?  And in detriment of others, while at that?

You know, we have another wanker here starting another thread from
hell - one about allowing stable driver ABI, to make the life of
proprietary modules more convenient.  The funny thing is, it's _also_
said to be for the benefit of users.  I.e. it's basically an equivalent
of "Will somebody think of chiiildrun!!!?!?!?"
 
> > No.  Permission denied.
> 
> Your opinion is duly noted.  Thanks.

It's not an opinion.  It's a lack of permission to distribute GPLv2 code
under conditions violating its license.

> > If somebody wants to dual-license *others* code,
> 
> This is not about dual licensing at all, and this is not about others
> code.  This is a decision you would have to make in order to enable
> cooperation between projects.
>
> If you don't want to make this decision, that's fine.  Nobody can be
> forced to cooperate.  This works in both directions.
> 
> Don't try to frame those who want to respect and defend users'
> freedoms as uncooperative.  This is *your* decision, and your decision
> alone.

Ah.  Got it.  Nice spin.  "Your license doesn't allow to put your code
under the license we want, you are mean and uncooperative!  Giiiimmeeee!!!
Or be condemned as a Bad Person and an Enemy of Freedom"
