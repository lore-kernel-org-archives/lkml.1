Return-Path: <linux-kernel-owner+w=401wt.eu-S1758019AbXISMOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019AbXISMOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 08:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753357AbXISMNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 08:13:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53621 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbXISMNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 08:13:54 -0400
Date: Wed, 19 Sep 2007 17:46:30 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Kyle Moffett <mrmacman_g4@mac.com>
cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: NFS4 authentification / fsuid
In-Reply-To: <A5318C25-7864-453A-B09A-00232D9EAF2A@mac.com>
Message-ID: <alpine.LFD.0.999.0709191704300.7162@enigma.security.iitk.ac.in>
References: <Pine.LNX.4.64.0708301610290.24730@fbirervta.pbzchgretzou.qr>
 <1188484155.6755.38.camel@heimdal.trondhjem.org> <1188484337.6755.41.camel@heimdal.trondhjem.org>
 <Pine.LNX.4.64.0708301640030.24730@fbirervta.pbzchgretzou.qr>
 <1188486240.6755.51.camel@heimdal.trondhjem.org> <20070830214431.GF10808@fieldses.org>
 <alpine.LFD.0.999.0709061333410.3781@enigma.security.iitk.ac.in>
 <20070906150616.GA28565@fieldses.org> <0D66E86D-8D97-45D7-9C2A-7AB5F42845B5@mac.com>
 <1189121714.6672.38.camel@heimdal.trondhjem.org> <5B1FC03A-6819-4C6C-91D3-F3022B798EF4@mac.com>
 <alpine.LFD.0.999.0709190503250.26241@enigma.security.iitk.ac.in>
 <A5318C25-7864-453A-B09A-00232D9EAF2A@mac.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 19 Sep 2007, Kyle Moffett wrote:
> 
> On Sep 18, 2007, at 19:44:59, Satyam Sharma wrote:
> > 
> > The whole *point* here is to secure against physical access -- then how can
                                                ^^^^^^^^^^^^^^^
> > you assume "barring disassembling the system"? If you're not considering
> > attacks such as those, then how _are_ you solving the physical access
> > problem in the first place? :-)
> 
> [snip lots of totally irrelevant stuff]

???

What is your point, really?

Let me repeat the situation:

I own a computer (maybe portable one, such as a laptop) that I want to
protect from attackers with physical access to my system. You're proposing
a scheme that claims to secure it (against attackers with physical access)
but assumes: "barring disassembling the system".

Dude, looks like you're selling snake oil here.


> > > Under this setup, tinkering with my BIOS does virtually nothing; the only
> > > avenues of attack are strictly of the "Install a hardware keylogger"
> > > variety.
> > 
> > Doesn't flashing/replacing your BIOS firmware/chip count as tinkering?  Then
> > I don't really need a "hardware keylogger", do I ...
> 
> Ok, so you are saying your plan of attack on this system would be:
>  1)  Steal the laptop such that I don't notice it has been stolen
>  2)  Open it up
>  3)  Replace the very-vendor-specific BIOS chip with a reflashed one with
> sufficient storage to do all the things the old BIOS could *AND* have enough
> storage for an entire replacement kernel binary with a built-in keylogger, as
> well as some storage for the logged password
>  4)  Return the laptop, again such that I don't notice it has been missing
>  5)  Wait for me to boot and type my password
>  6)  Somehow recover the laptop *yet* *again* to get the password back off of
> it and decrypt the disk

Precisely. Do you think the above attack is "fantastical"?

Wow, you're amazingly naive ... good luck ;-)

[ See, if it's only your kid sister that you want to "protect" your
  36GB worth of porn from, then you might as well use Windoze and one of
  those cute little "folder-locking" tool that we wrote back in 5th grade.

  However, if "hapless North Korean spy in Washington" describes you more
  accurately, then you better be ready for all sorts of attacks -- from
  exploding cigars [1], to poisoned ballpoint pens [2] :-)

  In short, you have no clue what you're talking about, and thankfully
  I'm not using any security software you had any part in designing :-) ]


> Yes it "can be done", but so can dumping the firmware for an iPod out through
> the built-in piezo clicker[1].  USE SOME COMMON SENSE HERE PEOPLE!!!  The only
> "unbreakable" computer is one always disconnected and off under armed guard in
> a bank vault, and even then it's only as secure as the bank in which it is
> stored (which get broken into on occasion).

Thanks for repeatedly making *my* point :-)

_You_ are the one who claimed protecting systems from attackers with
physical access to be a "fairly simple" problem ... and here you're
mentioning how *difficult* it is ...


> I am assuming that if the laptop has sufficiently important data on it to
> warrant the above steps then I am also clueful enough to:
>  (A)  Not carry the laptop around unsecured areas,

You might carry it home, might you not? What if your lover/girlfriend/wife
is one of them? [3]


>  (B)  Keep a close enough eye on it and be aware that it's gone by the time
> they get to step 2, OR

Hmm, you'd need to be a mutant to keep "close enough eyes" on your stuff
while you're sleeping ... or drugged (?)


>  (C)  Pay somebody to build me a better physical chassis for my laptop

ROTFL ... these "workarounds" above are even more hilarious than your
earlier "fairly simple" claim.


> We are talking about *STANDARD* laptop systems with reasonably alert users.
> If the user doesn't know how to properly protect the stuff on the laptop then
> they probably don't know how to properly protect the other copy in their
> heads, either.

Dude, if the data in there is really that important, then better not
store it on a computer / disk at all :-)


> Besides, if some government wanted the data on your laptop
> that bad they'd just pick you up in the middle of the night and torture your
> password out of you.

Surprisingly, you have (somewhat of) a point (!)


> On Sep 18, 2007, at 19:48:16, Satyam Sharma wrote:
> > On Fri, 7 Sep 2007, Kyle Moffett wrote:
> > > So you can't draw any relationships between "Protect the end-user" with
> > > "Protect the device FROM the end-user", the former can be done very
> > > reliably to whatever level of risk-reduction you need and the latter can't
> > > practically be done at all.
> > 
> > Well, you're the one who called solving the physical access problem "easy"
> > here ... :-)
> 
> If your system equates end-user with attacker
  ^^

"If"? Was there ever any doubt?

Heh, did you even read the thread you just replied to?

We're talking of consoles / hardware sold by commercial companies to
users here, where they want explicitly want to prevent the users from
being able to hack it. So yes, end user == attacker.

> then you are *screwed* regardless!

Ah, finally you make my point again for me :-)


Thanks for the laughs,

Satyam


[1] }
[2] } All real "attacks". History pop quiz: on whom? ;-)
[3] }
