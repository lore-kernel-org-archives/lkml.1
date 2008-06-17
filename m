Return-Path: <linux-kernel-owner+w=401wt.eu-S1760705AbYFQXdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760705AbYFQXdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 19:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758788AbYFQXdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 19:33:43 -0400
Received: from trinity.fluff.org ([89.145.97.151]:56667 "EHLO
	trinity.fluff.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690AbYFQXdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 19:33:42 -0400
Date: Wed, 18 Jun 2008 00:33:40 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       Harald Welte <laforge@openmoko.org>, Thomas Kleffel <tk@maintech.de>,
       Roman Moravcik <roman.moravcik@gmail.com>
Subject: Re: [patch 11/15] MMC: Fix the retcode in the S3C24XX MMC/SD driver
Message-ID: <20080617233340.GE10351@trinity.fluff.org>
References: <20080606155117.074799346@fluff.org.uk> <20080606155526.681793235@fluff.org.uk> <20080614182505.058cefe3@mjolnir.drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080614182505.058cefe3@mjolnir.drzeus.cx>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.9i
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2008 at 06:25:05PM +0200, Pierre Ossman wrote:
> On Fri, 06 Jun 2008 16:51:28 +0100
> Ben Dooks <ben-linux@fluff.org> wrote:
> 
> > Fix the error codes
> > 
> > Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> > 
> 
> NAK, for rather obvious reasons.

Fixed and folded back into patch #2.

thanks,
-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

