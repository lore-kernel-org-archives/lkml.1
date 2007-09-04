Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbXIDQ7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbXIDQ7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 12:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754734AbXIDQ70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 12:59:26 -0400
Received: from keil-draco.com ([216.193.185.50]:50176 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbXIDQ7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 12:59:24 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: James Bruce <bruce@andrew.cmu.edu>
Subject: Re: Fwd: That whole "Linux stealing our code" thing
Date: Tue, 4 Sep 2007 12:59:12 -0400
User-Agent: KMail/1.9.6
Cc: Krzysztof Halasa <khc@pm.waw.pl>, davids@webmaster.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
References: <MDEHLPKNGKAHNMBLJOLKOEDKGJAC.davids@webmaster.com> <200709031504.17454.dhazelton@enter.net> <46DD1C5A.9060708@andrew.cmu.edu>
In-Reply-To: <46DD1C5A.9060708@andrew.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709041259.13137.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 September 2007 04:50:34 James Bruce wrote:
> Daniel Hazelton wrote:
> > On Monday 03 September 2007 14:26:29 Krzysztof Halasa wrote:
> >> Daniel Hazelton <dhazelton@enter.net> writes:
> >>> The fact
> >>> remains that the person making a work available under *ANY* form of
> >>> copyright
> >>> license has the right to revoke said grant of license to anyone.
> >>
> >> Not after the licence has been given and accepted (and there might be
> >> restrictions), unless of course the licence contained such reservation.
> >
> > I hate to belabor the point, but you seem to be making the mistake of
> > "The license applies to the copyright holder" that I've seen a lot of
> > people make (and kept quiet about).
>
> I believe you are making the mistake that the license on code has
> anything to do with what the author chooses to do in the future.
> Releasing something as BSD does not force the author to do anything in
> the future with his code, and he/she could add and relicence as he/she
> feels fit.  HOWEVER, that particular code has already been released as
> BSD, and the author no longer has control over that release.

I may be mistaken, but it has always been my understanding that, unless you 
specifically waive your rights, they are automatically retained. (Under the 
law in the US, at least).

Hence, a copyright holder can do such, where the license has not been acquired 
by money changing hands.

(And actually, my above statement isn't rendered false by your rebuttal - it 
still appears that the person I replied to believes that a copyright license 
applies to the person holding the copyright in the same manner it applies to 
the person receiving the item under said license. Though I will admit it if I 
am wrong - publicly)

> > The person holding the copyright has all the legal standing to revoke a
> > license grant at any time. Licenses such as the GPL are not signed
> > contracts, and that means there are limits to what effect they can have
> > on the copyright holder.
>
> I believe you are confusing the fact that an author can decide to
> release code under another license, with the existence of code under
> that earlier license.  The license grant comes from THE CODE (which
> bears a license), not THE AUTHOR.  I can use GPL code I get in the mail
> because the license on the work says I can do so, not because I
> contacted the author and got a specific grant.  If such a grant were
> only verbal, your theory might hold, but that doesn't apply to any OSS
> software under discussion here.

The license is a direct grant from the author. If the author so wished, he/she 
could pull the license - either entirely or in part. About the only caveat is 
that the author would have to publish and attempt to contact everyone who may 
have acquired the item under that license to inform them of such a change - 
this does make it difficult, hell, makes it nearly impossible, but it can be 
done. (IANAL, but this does appear to be what the law says)

> If your legal theory were true, I could sell you a book and then later
> demand that you destroy it.  I could also release something as public
> domain, and then later rescind that (I still hold the copyright on what
> I produced), and charge money from anyone who used it.  I think its safe
> to say that this does not happen in practice.  Please provide some
> examples to the contrary or caselaw if you want to convince me otherwise.

Actually, no. A purchase does automatically grant the rights inherent in 
ownership - but that is a *PURCHASE*. Mere transfer of an item with no 
exchange of money cannot convey those rights. As far as the 'public domain' 
argument goes... That smells of a straw-man and is as different from a grant 
of license as it is from a purchase. When you release something into the 
public domain you are waiving *ALL* of your rights as copyright holder. 
(Which, I am told, cannot be done in Germany and some other countries)

> Furthermore, BSD/GPL software could not really exist under your legal
> theory; A programmer who wrote 30 year old core BSD code could wake up
> tomorrow and decide to require all BSD derivatives to remove his code or
> pay him for it (and the next day he could change the price again).  Open
> source software would not exist if such a liability were true, and
> companies like Sun could not be built up off of derivatives of it.
> Linux 0.01 is still available under a pre-GPL license if you can find a
> copy, and neither Linus (nor anyone else) can change that.

He could, but AFAICT, thirty years ago BSD was still run entirely by UC 
Berkely and any copyrights that might be held are held entirely by UC Berkely 
and not the individuals that contributed to such. (Whats more, a 30 year old 
version of BSD doesn't meet the requirements of the AT&T agreement, so its 
only legal in-so-far as it massively predates that agreement (and the lawsuit 
which spawned it) :)

And yes, Linus actually could revoke the license on any copy of Linux from 
before he started merging code written by other people into the code-base. 
After the first time he merged another persons code he lost that unilateral 
right. (He could, still, revoke the right to *his* portions of the code, 
however)

> > If the license was of the "signed contract" type, or contained text
> > stating that the copyright holder was giving up all rights of revocation
> > (etc...) I could agree with you. As it stands, no "Open Source" license
> > that I have seen used on a major project contains any part that does
> > that. In fact, the GPL is the only license I can name (offhand) that even
> > touches on the rights of the copyright holder - and then it is in the
> > form of "If you do X, Y or Z all rights granted under this license are
> > automatically revoked".
> >
> > That is an "automatic clause" - not a limitation stating that the
> > copyright holder can only revoke under those conditions. The person
> > holding the copyright has quite a few rights - more than people believe -
> > and not even the most generous of Open Source licenses (except those that
> > contain text like "granted in perpetuity" or similar) even come close to
> > being exempt from the holder of the copyright not being able to summarily
> > revoke a given persons license.
>
> There are plenty of rights, but retroactive changes to the license terms
> of something you've already distributed is not one of them.

I'm not talking about retro-active changes. I'm talking about the copyright 
holder exercising their right to cancel said license in regards to either a 
specific person, a specific group of people or everyone. Cancelling a license 
is not altering the terms - it's stating "I am removing this product from 
release under this license entirely".

(Though I have never said doing such is *EASY*, and I never said that doing 
such would be free from people throwing lawsuits around. It's because of 
those two facts that it has only rarely ever been done - even by large 
companies.)

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
