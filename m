Return-Path: <linux-kernel-owner+w=401wt.eu-S1762432AbYF3RJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762432AbYF3RJq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 13:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbYF3RJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 13:09:36 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:53391 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbYF3RJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 13:09:35 -0400
X-Greylist: delayed 1763 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jun 2008 13:09:35 EDT
Date: Tue, 1 Jul 2008 00:36:01 +0800
From: Harald Welte <laforge@openmoko.org>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, linux-kernel@vger.kernel.org,
       tk@maintech.de
Subject: Re: [patch v4 02/17] MMC: S3C24XX: Fix the checkpatch.pl errors in
	the s3cmci driver
Message-ID: <20080630163601.GD5043@prithivi.gnumonks.org>
References: <20080630152547.755285683@fluff.org.uk> <20080630152747.132370982@fluff.org.uk> <20080630175018.356568b7@mjolnir.drzeus.cx> <20080630161537.GD8489@trinity.fluff.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080630161537.GD8489@trinity.fluff.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 05:15:37PM +0100, Ben Dooks wrote:
> On Mon, Jun 30, 2008 at 05:50:18PM +0200, Pierre Ossman wrote:
> > On Mon, 30 Jun 2008 16:25:49 +0100
> > Ben Dooks <ben-linux@fluff.org> wrote:
> > 
> > > Fix the checkpatch and other problems pointed out by
> > > akpm.
> > > 
> > > Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> > > 
> > 
> > I prefer to have this one merged into 01 as you'll end up with a commit
> > that you cannot compile otherwise. Besides, running checkpatch is
> > something you do before submitting anyway, not as a separate cleanup. :)
> 
> In this case I kept it seperate as the cleanups where done by myself
> as the original driver authour is not interested or too busy to do
> these himself. Basically, I was trying to keep the driver and my own
> cleanup work seperate.

don't worry about that.  Thomas Kleffel is unlikely to return to do any
active work on it (I know him personally), and the OpenMoko community
will inevitably rebase its patches based on whatever ends up in
mainline.  So nobody is worried if you merge all that stuff into one
patch.  It's probably polite to add the significant contributors (such
as yourself and myself) to the list of authors at the beginning of the
file though - given the amount of changes the driver has received
compared to Tomas' original.

Thanks for all your work,
-- 
- Harald Welte <laforge@openmoko.org>          	        http://openmoko.org/
============================================================================
Software for the world's first truly open Free Software mobile phone
