Return-Path: <linux-kernel-owner+w=401wt.eu-S1761982AbYGBIjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761982AbYGBIjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 04:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbYGBIjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 04:39:11 -0400
Received: from trinity.fluff.org ([89.145.97.151]:60758 "EHLO
	trinity.fluff.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbYGBIjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 04:39:10 -0400
Date: Wed, 2 Jul 2008 09:39:06 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: RFC: Add mtdset= to Documentation/kernel-parameters
Message-ID: <20080702083906.GQ8489@trinity.fluff.org>
References: <20080701215726.GA22880@fluff.org.uk> <20080701221732.GA16816@flint.arm.linux.org.uk> <Pine.LNX.4.64.0807011524520.26330@shark.he.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807011524520.26330@shark.he.net>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.9i
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 03:26:24PM -0700, Randy.Dunlap wrote:
> On Tue, 1 Jul 2008, Russell King - ARM Linux wrote:
> 
> > On Tue, Jul 01, 2008 at 10:57:26PM +0100, Ben Dooks wrote:
> > > Does anyone have any comments about adding this patch
> > > to describe the ARM/S3C2412 Jive machine specific kernel
> > > commandline parameter mtdset?
> > 
> > Only that it should be part of the patch which adds the mtdset=
> > parameter rather than a separate stand alone patch.
> 
> Not caused by this patch, but Documentation/kernel-parameters.txt
> needs a "ARM" entry/description near the top of the file in the
> section that begins with:

I'll submit a patch to add this later.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

