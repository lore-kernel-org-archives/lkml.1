Return-Path: <linux-kernel-owner+w=401wt.eu-S1030453AbXCVKry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030453AbXCVKry (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 06:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030456AbXCVKry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 06:47:54 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:41996 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030367AbXCVKrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 06:47:52 -0400
Date: Thu, 22 Mar 2007 11:49:57 +0100
From: Lukas Hejtmanek <xhejtman@mail.muni.cz>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: libata - 2.6.21-rc4-git5, ata channel still badly configured
Message-ID: <20070322104957.GA3621@mail.muni.cz>
References: <20070321213757.GB3637@mail.muni.cz> <460225EA.9060409@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <460225EA.9060409@gmail.com>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Muni-Spam-TestIP: 147.251.54.96
X-Muni-Envelope-From: xhejtman@fi.muni.cz
X-Muni-Envelope-To: alan@lxorguk.ukuu.org.uk
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Thu, 22 Mar 2007 11:47:50 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2007 at 03:44:58PM +0900, Tejun Heo wrote:
> Lukas Hejtmanek wrote:
> >> Subject    : ata_piix: PATA UDMA/100 configured as UDMA/33
> >> References : http://lkml.org/lkml/2007/2/20/294
> >> Submitter  : Fabio Comolli <fabio.comolli@gmail.com>
> >> Status     : patch exists
> > 
> 
> Does this fix your problem?

Yes, it does. Thank you.

-- 
Luká¹ Hejtmánek
