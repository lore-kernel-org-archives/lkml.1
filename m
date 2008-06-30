Return-Path: <linux-kernel-owner+w=401wt.eu-S1762584AbYF3RVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762584AbYF3RVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 13:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbYF3RUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 13:20:55 -0400
Received: from touchdown.maintech.de ([87.106.18.11]:57449 "EHLO mail.wvpn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbYF3RUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 13:20:54 -0400
X-Greylist: delayed 612 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jun 2008 13:20:54 EDT
Message-ID: <486911B2.7000006@maintech.de>
Date: Mon, 30 Jun 2008 19:02:42 +0200
From: Thomas Kleffel <tk@maintech.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Harald Welte <laforge@openmoko.org>
CC: Ben Dooks <ben-linux@fluff.org>, Pierre Ossman <drzeus-mmc@drzeus.cx>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch v4 02/17] MMC: S3C24XX: Fix the checkpatch.pl errors in
 the s3cmci driver
References: <20080630152547.755285683@fluff.org.uk> <20080630152747.132370982@fluff.org.uk> <20080630175018.356568b7@mjolnir.drzeus.cx> <20080630161537.GD8489@trinity.fluff.org> <20080630163601.GD5043@prithivi.gnumonks.org>
In-Reply-To: <20080630163601.GD5043@prithivi.gnumonks.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
> don't worry about that.  Thomas Kleffel is unlikely to return to do any
> active work on it (I know him personally), and the OpenMoko community
> will inevitably rebase its patches based on whatever ends up in
> mainline.  So nobody is worried if you merge all that stuff into one
> patch.  It's probably polite to add the significant contributors (such
> as yourself and myself) to the list of authors at the beginning of the
> file though - given the amount of changes the driver has received
> compared to Tomas' original.
>   
Harald is 100% right. I have absolutely no time at all to maintain this 
driver and I haven't worked on it (or any other SD/MMC related stuff) 
for almost two years now.

I'd like to thank Harald, Ben, Pierre and all others who are working 
hard to get the driver merged.

See you,

Thomas Kleffel



