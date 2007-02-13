Return-Path: <linux-kernel-owner+w=401wt.eu-S1750812AbXBMQTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750812AbXBMQTg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 11:19:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750809AbXBMQTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 11:19:36 -0500
Received: from ns1.suse.de ([195.135.220.2]:54040 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbXBMQTf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 11:19:35 -0500
From: Jean Delvare <jdelvare@suse.de>
Organization: SuSE Linux
To: Leopold Palomo-Avellaneda <lepalom@wol.es>
Subject: Re: Sata_via problems in a Vintage2-AE1
Date: Tue, 13 Feb 2007 17:19:47 +0100
User-Agent: KMail/1.9.1
Cc: Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jeff Garzik <jgarzik@pobox.com>
References: <200702090010.06897.lepalom@wol.es> <200702131220.21690.jdelvare@suse.de> <200702131711.11781.lepalom@wol.es>
In-Reply-To: <200702131711.11781.lepalom@wol.es>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-13"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702131719.47507.jdelvare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le Mardi 13 Février 2007 17:11, Leopold Palomo-Avellaneda a écrit :
> A Dimarts 13 Febrer 2007 12:20, Jean Delvare va escriure:
> (...)
> > > > *If* the VT8251 needs the VIA IRQ quirk, then the attached patch may
> > > > help. Leopold, can you give it a try?
> > >
> > > Well, making your patch to the vanilla 2.6.20 the result is the same.
> > > The box doesn't boot. Always the same problem ....
> >
> > If it's not a VIA IRQ problem, then there's nothing more I can do, sorry.
> > Someone else will have to look into the problem.
> >
> > Out of curiosity, with my patch applied, did you see any "VIA VLink IRQ
> > fixup" messages on the console?
>
> No :-(

OK, so maybe the VT8251 actually no longer needs the quirk. Thanks for testing 
and reporting.

-- 
Jean Delvare
Suse L3
