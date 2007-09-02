Return-Path: <linux-kernel-owner+w=401wt.eu-S965879AbXIBLvC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965879AbXIBLvC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 07:51:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965029AbXIBLuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 07:50:46 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:44065 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965776AbXIBLuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 07:50:40 -0400
Date: Sun, 2 Sep 2007 13:50:41 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Igor Sobrado <igor@condmat1.ciencias.uniovi.es>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Constantine A. Murenin" <mureninc@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Fwd: That whole "Linux stealing our code" thing
Message-ID: <20070902115041.GM16016@stusta.de>
References: <200709010140.l811eq9H005896@cvs.openbsd.org> <f34ca13c0709010948v67b04b58lb098713dc38c4d6a@mail.gmail.com> <46D99FB7.6030505@garzik.org> <f34ca13c0709011037p221cb40fjf69651d1858df212@mail.gmail.com> <20070901205457.GK9260@stusta.de> <20070902113638.78fbd202@the-village.bc.nu> <Pine.LNX.4.64.0709021303001.4312@condmat1.ciencias.uniovi.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709021303001.4312@condmat1.ciencias.uniovi.es>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 02, 2007 at 01:20:27PM +0200, Igor Sobrado wrote:
> On Sun, 2 Sep 2007, Alan Cox wrote:
>> You can shout this all you like but you would be wrong. You can remove
>> the licence if you have permission to do so. For the ath c files there
>> was permission to do so.
>
> There was permission to do so from Reyk Floeter?  Really?
>
>> Your understanding isn't quite right. One of many things you may get with
>> dual licensed code is the right to pick a licence from several choices,
>> you may also get the right to remove some choices from the recipient.
>
> Reyk code was never dual licensed!  His code is under truly free licensing 
> terms (BSD).

Jiri's patch touched both files containing BSD-only code by Reyk and 
code Reyk contributed to leaving the file dual licenced.

>> A work that combines GPL and BSD licensed material is not the same as a
>> work which says I may choose between two licences. If both licences must
>> always apply (which is a perfectly possible condition to put in a
>> licence) then putting such a "both" GPL/BSD licence piece of code into
>> OpenBSD would require any OpenBSD distributed containing it was GPL
>> licenced when conveyed, which I am *very* sure is not the intent.
>>
>> Thus what you appear to be doing by putting the ath5k C code in OpenBSD is
>> conveying it under the BSD licence (making a choice between the two
>> offered) and conveying a right for parties down the chain to convey it
>> under one of the licences only.
>
> I think that Theo explained this point clearly quite a few times in the 
> last days.
>
>> And as we've already established the header files are quite different.
>
> Is a simple change in the header files a reason to vindicate the people 
> that changed the licensing terms?  Obviously, it isn't.
>
>> Doesn't mean its not somewhat rude but illegal and rude are two very
>> different things.
>
> No, because this change is both rude and illegal.

You mixed two completely different things in your email:

1. Jiri's patch (that was never merged into Linux) not only removed the 
   BSD header from dual licenced files but also from not dual licenced
   files.

2. Theo accused Alan that telling people that it was OK to choose one 
   licence for dual licenced code was "advising people to break the law".

Jiri's patch was legally not OK regarding 1. - there's no discussion 
regarding this.

The point 2 is what the email of Theo that was forwarded to linux-kernel 
is about and what the discussion is about. That's quite a rude action 
by Theo unless he's able to prove that this accusation is correct.

> Igor

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

