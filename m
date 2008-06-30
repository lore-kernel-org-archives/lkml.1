Return-Path: <linux-kernel-owner+w=401wt.eu-S1763732AbYF3THf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763732AbYF3THf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 15:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753694AbYF3TH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 15:07:27 -0400
Received: from trinity.fluff.org ([89.145.97.151]:42830 "EHLO
	trinity.fluff.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbYF3TH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 15:07:26 -0400
Date: Mon, 30 Jun 2008 20:07:17 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, Harald Welte <laforge@openmoko.org>,
       linux-kernel@vger.kernel.org, tk@maintech.de
Subject: Re: [patch v4 02/17] MMC: S3C24XX: Fix the checkpatch.pl errors in the s3cmci driver
Message-ID: <20080630190717.GG8489@trinity.fluff.org>
References: <20080630152547.755285683@fluff.org.uk> <20080630152747.132370982@fluff.org.uk> <20080630175018.356568b7@mjolnir.drzeus.cx> <20080630161537.GD8489@trinity.fluff.org> <20080630163601.GD5043@prithivi.gnumonks.org> <20080630170408.GE8489@trinity.fluff.org> <20080630201019.4af5dbf2@mjolnir.drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080630201019.4af5dbf2@mjolnir.drzeus.cx>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.9i
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 08:10:19PM +0200, Pierre Ossman wrote:
> On Mon, 30 Jun 2008 18:04:08 +0100
> Ben Dooks <ben-linux@fluff.org> wrote:
> 
> > 
> > You have missed part of the point. My extra work is not a small
> > set of changes which won't get counted when profiling the Kernel
> > contributors. My employers have given me time to sort these
> > items out, and we do get work off the fact that we're shown to be in
> > the leading contributors (iirc, 18th last-year) so I was trying to
> > ensure that this wasn't lost.
> > 
> 
> I can appreciate that, but I do not want a commit in the tree that
> doesn't even compile. You don't have to merge in all the other ones
> (which should give you a reasonable blip in the statistics), but at
> least #1 and #2.

Ok, I'll sort out reposting this.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

