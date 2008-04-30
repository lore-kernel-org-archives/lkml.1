Return-Path: <linux-kernel-owner+w=401wt.eu-S1760828AbYD3QQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760828AbYD3QQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 12:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756158AbYD3QQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 12:16:18 -0400
Received: from mail-ausfall.charite.de ([193.175.70.131]:39074 "EHLO
	mail-ausfall.charite.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108AbYD3QQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 12:16:18 -0400
Date: Wed, 30 Apr 2008 18:16:15 +0200
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: Linux Kernel Maillist <linux-kernel@vger.kernel.org>,
       Sven_Rudolph@drewag.de
Subject: Re: HP server and atto driver from hell
Message-ID: <20080430161615.GC6980@charite.de>
Mail-Followup-To: "Moore, Eric" <Eric.Moore@lsi.com>,
	Linux Kernel Maillist <linux-kernel@vger.kernel.org>,
	Sven_Rudolph@drewag.de
References: <20080430134248.GD15819@charite.de> <0631C836DBF79F42B5A60C8C8D4E8229010475E9@NAMAIL2.ad.lsil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0631C836DBF79F42B5A60C8C8D4E8229010475E9@NAMAIL2.ad.lsil.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Moore, Eric <Eric.Moore@lsi.com>:

> > According to http://lwn.net/Articles/254394, Eric Moore added the ATTO
> > 4LD support:
> > 
> > mpt fusion: Add support for ATTO 4LD: Rebranded LSI
> > 
> > And the HP U320e SCSI Bus Adapter seesm to be a rebranded ATTO 4LD.
> > But I cannot be sure.
> > 
> 
> Yeah, ATTO support was added about a year ago, thanks to Sven Rudolph.
> However I doubt HP card is *not* a rebranded ATTO card.  They both have
> the same scsi controller, but the bios and firmware on the HP card are
> directly from LSI, however I'm pretty sure that ATTO did everything
> themselves. 

You mean it probably won't work at all with the drive mpt spi driver?

-- 
Ralf Hildebrandt (i.A. des IT-Zentrums)         Ralf.Hildebrandt@charite.de
Charite - Universitätsmedizin Berlin            Tel.  +49 (0)30-450 570-155
Gemeinsame Einrichtung von FU- und HU-Berlin    Fax.  +49 (0)30-450 570-962
IT-Zentrum Standort CBF                 send no mail to snickebo@charite.de
