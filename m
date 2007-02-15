Return-Path: <linux-kernel-owner+w=401wt.eu-S965888AbXBOLXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965888AbXBOLXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 06:23:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965887AbXBOLXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 06:23:40 -0500
Received: from violet.upc.es ([147.83.2.51]:34856 "EHLO violet.upc.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965885AbXBOLXj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 06:23:39 -0500
From: Leopold Palomo-Avellaneda <lepalom@wol.es>
To: Jean Delvare <jdelvare@suse.de>
Subject: Re: Sata_via problems in a Vintage2-AE1: Resume
Date: Thu, 15 Feb 2007 12:23:18 +0100
User-Agent: KMail/1.9.5
Cc: Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jeff Garzik <jgarzik@pobox.com>
References: <200702090010.06897.lepalom@wol.es> <200702131711.11781.lepalom@wol.es> <200702131719.47507.jdelvare@suse.de>
In-Reply-To: <200702131719.47507.jdelvare@suse.de>
MIME-Version: 1.0
Message-Id: <200702151223.19333.lepalom@wol.es>
X-MIMETrack: Itemize by SMTP Server on Ackerman/UPC(Release 5.0.12  |February 13, 2003) at
 15/02/2007 12:23:20,
	Serialize by Router on Ackerman/UPC(Release 5.0.12  |February 13, 2003) at
 15/02/2007 12:23:22,
	Serialize complete at 15/02/2007 12:23:22
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
  charset="iso-8859-13"
Content-Disposition: inline
X-Mail-Scanned: Criba 2.0 + Clamd
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.0.2 (violet.upc.es [147.83.2.51]); Thu, 15 Feb 2007 12:23:23 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A Dimarts 13 Febrer 2007 17:19, Jean Delvare va escriure:
> Le Mardi 13 Février 2007 17:11, Leopold Palomo-Avellaneda a écrit :
> > A Dimarts 13 Febrer 2007 12:20, Jean Delvare va escriure:
> > (...)
> >
> > > > > *If* the VT8251 needs the VIA IRQ quirk, then the attached patch
> > > > > may help. Leopold, can you give it a try?
> > > >
> > > > Well, making your patch to the vanilla 2.6.20 the result is the same.
> > > > The box doesn't boot. Always the same problem ....
> > >
> > > If it's not a VIA IRQ problem, then there's nothing more I can do,
> > > sorry. Someone else will have to look into the problem.
> > >
> > > Out of curiosity, with my patch applied, did you see any "VIA VLink IRQ
> > > fixup" messages on the console?
> >
> > No :-(
>
> OK, so maybe the VT8251 actually no longer needs the quirk. Thanks for
> testing and reporting.


Hi people,
 
arriving to this state. What do you recommend?

I have the box more or less working with irqpoll but with a lot of messages:
APIC error on CPU0: 08(08)

and the box doesn't boot without the irqpoll option. Do you think that the 
2.6.21 have some kind of changes in this area?

Thank's for all for you patience and your messages.

Best regards,

Leo
