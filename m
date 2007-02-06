Return-Path: <linux-kernel-owner+w=401wt.eu-S933159AbXBFSHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159AbXBFSHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 13:07:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933177AbXBFSHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 13:07:51 -0500
Received: from web38515.mail.mud.yahoo.com ([209.191.125.61]:31257 "HELO
	web38515.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933159AbXBFSHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 13:07:50 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=rCYD5ROmpjAU1rMljm3HTWTiMznLeDc4uZiX1rEFiTj+m6vIrk1sIrTuiJ6PpZDQWYpQXQnIXla0Am9dTVMOt8Y+yL68MDoJsHfFojt1/uXQPrlSviAY7V7KntlQrXUmMkKzDfrPsUkOd77jOSIQo+6bror6nCL+SxQZX7YQPrs=;
X-YMail-OSG: QYGBSjYVM1lBlK7bbWldznFMA5mWi7dP.bPuSkplU.VO0cBV9cgckb1rQTO_vWqP8iTb1ieQdqE9DBbEHXLyT265t4ZUYY2352cZ_3ugav.7HYh79eAT8A--
Date: Tue, 6 Feb 2007 10:07:50 -0800 (PST)
From: Levitsky Maxim <maximlevitsky@yahoo.com>
Subject: Re: Question: Status of marvell's PATA 88SE6101 controller on intel boards
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070206174428.7ca93476@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <223870.54188.qm@web38515.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Alan <alan@lxorguk.ukuu.org.uk> wrote:

> > I also noticed that 2.6.20 adds experimentally support for that chip.
> > But driver says that it enables it via 'legacy mode'
> 
> Yes.
> 
> > I will be glad to hear whenever full support is planned or not.
> 
> At the moment it is not, but it may be a neccessary side effect of full
> support for the later SATA capable controllers in native SATA mode. In
> which case you might get it one day.
> 
> The legacy mode is itself as good as most typical PATA controllers and
> better than some.

And I don't need anything better , just normal recording on my PATA DVD writer.
I now have very old system and still DVD recording works fine , so I don't need anything more than
that

> >
> > And as last thing I want to ask you whenever current support is usable, 
> > that is can I use DMA , can I use DVD as at least reader for CD/DVD , 
> > and even better can I burn disks with it ( although I can live without it)
> 
> The legacy mode has full DMA support. What you don't get is the ability
> to queue multiple commands so the hardware can fire off a new command as
> the first completes and to have the hardware do some of the general
> poking around for us. 

So that means that DVD-writer will work too ?

> 
> Alan
> 

Thank you very much, I didn't expect so quick response.


Thank you, kernel developers for so great kernel.
              Maxim Levitsky



 
____________________________________________________________________________________
Looking for earth-friendly autos? 
Browse Top Cars by "Green Rating" at Yahoo! Autos' Green Center.
http://autos.yahoo.com/green_center/
