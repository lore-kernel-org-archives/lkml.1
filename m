Return-Path: <linux-kernel-owner+w=401wt.eu-S1760431AbYF3Rbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760431AbYF3Rbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 13:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbYF3Rb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 13:31:27 -0400
Received: from trinity.fluff.org ([89.145.97.151]:52128 "EHLO
	trinity.fluff.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbYF3Rb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 13:31:27 -0400
Date: Mon, 30 Jun 2008 18:31:23 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Thomas Kleffel <tk@maintech.de>
Cc: Harald Welte <laforge@openmoko.org>, Ben Dooks <ben-linux@fluff.org>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>, linux-kernel@vger.kernel.org
Subject: Re: [patch v4 02/17] MMC: S3C24XX: Fix the checkpatch.pl errors in the s3cmci driver
Message-ID: <20080630173123.GF8489@trinity.fluff.org>
References: <20080630152547.755285683@fluff.org.uk> <20080630152747.132370982@fluff.org.uk> <20080630175018.356568b7@mjolnir.drzeus.cx> <20080630161537.GD8489@trinity.fluff.org> <20080630163601.GD5043@prithivi.gnumonks.org> <486911B2.7000006@maintech.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486911B2.7000006@maintech.de>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.9i
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 07:02:42PM +0200, Thomas Kleffel wrote:
> Hi,
> >don't worry about that.  Thomas Kleffel is unlikely to return to do any
> >active work on it (I know him personally), and the OpenMoko community
> >will inevitably rebase its patches based on whatever ends up in
> >mainline.  So nobody is worried if you merge all that stuff into one
> >patch.  It's probably polite to add the significant contributors (such
> >as yourself and myself) to the list of authors at the beginning of the
> >file though - given the amount of changes the driver has received
> >compared to Tomas' original.
> >  
> Harald is 100% right. I have absolutely no time at all to maintain this 
> driver and I haven't worked on it (or any other SD/MMC related stuff) 
> for almost two years now.
> 
> I'd like to thank Harald, Ben, Pierre and all others who are working 
> hard to get the driver merged.

Thanks for your original work. I suppose I should add a signed-off-by:
line from you to the original driver.
 
> See you,
> 
> Thomas Kleffel

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

