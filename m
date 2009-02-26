Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbZBZTFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbZBZTFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 14:05:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbZBZTFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 14:05:39 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:3227 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868AbZBZTFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 14:05:35 -0500
Date: Thu, 26 Feb 2009 19:05:29 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
Subject: Re: [patch/rfc 2.6.29-rc6 1/2] regulator: enumerate voltages
Message-ID: <20090226190511.GD8595@sirena.org.uk>
References: <200902081037.06645.david-b@pacbell.net> <200902251702.03230.david-b@pacbell.net> <20090226104624.GA4229@sirena.org.uk> <200902261056.05740.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902261056.05740.david-b@pacbell.net>
X-Cookie: My haircut is totally traditional!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 10:56:05AM -0800, David Brownell wrote:
> On Thursday 26 February 2009, Mark Brown wrote:

> > Unless, of course, you happen to be using one of those consumers that
> > wants to know the voltage it's running at to configure itself.

> In which case it can ask the regulator what voltage it's using.  :)

I suspect we're talking at cross purposes here - I was talking about the
fixed voltage regulator driver.  I suspect you were talking about
something else?
