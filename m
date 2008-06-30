Return-Path: <linux-kernel-owner+w=401wt.eu-S1762796AbYF3QPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762796AbYF3QPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 12:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756812AbYF3QPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 12:15:39 -0400
Received: from trinity.fluff.org ([89.145.97.151]:49848 "EHLO
	trinity.fluff.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502AbYF3QPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 12:15:39 -0400
Date: Mon, 30 Jun 2008 17:15:37 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       tk@maintech.de, laforge@openmoko.org
Subject: Re: [patch v4 02/17] MMC: S3C24XX: Fix the checkpatch.pl errors in the s3cmci driver
Message-ID: <20080630161537.GD8489@trinity.fluff.org>
References: <20080630152547.755285683@fluff.org.uk> <20080630152747.132370982@fluff.org.uk> <20080630175018.356568b7@mjolnir.drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080630175018.356568b7@mjolnir.drzeus.cx>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.9i
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 05:50:18PM +0200, Pierre Ossman wrote:
> On Mon, 30 Jun 2008 16:25:49 +0100
> Ben Dooks <ben-linux@fluff.org> wrote:
> 
> > Fix the checkpatch and other problems pointed out by
> > akpm.
> > 
> > Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> > 
> 
> I prefer to have this one merged into 01 as you'll end up with a commit
> that you cannot compile otherwise. Besides, running checkpatch is
> something you do before submitting anyway, not as a separate cleanup. :)

In this case I kept it seperate as the cleanups where done by myself
as the original driver authour is not interested or too busy to do
these himself. Basically, I was trying to keep the driver and my own
cleanup work seperate.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

