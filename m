Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab0CEM1H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 07:27:07 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50582 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750816Ab0CEM1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 07:27:03 -0500
Date: Fri, 5 Mar 2010 12:29:23 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adam Jackson <ajax@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
Message-ID: <20100305122923.344e478e@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.1003041458140.3751@localhost.localdomain>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>
	<alpine.LFD.2.00.1003041015080.3588@localhost.localdomain>
	<alpine.LFD.2.00.1003041035380.3751@localhost.localdomain>
	<20100304185002.GA23532@srcf.ucam.org>
	<alpine.LFD.2.00.1003041051470.3751@localhost.localdomain>
	<20100304190450.GA23807@srcf.ucam.org>
	<alpine.LFD.2.00.1003041110070.3751@localhost.localdomain>
	<1267741697.1316.16.camel@atropine.boston.devel.redhat.com>
	<alpine.LFD.2.00.1003041458140.3751@localhost.localdomain>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So man up, guys. Face the problem, rather than say "well, it's staging", 
> or "well, we can revert it". Neither of those really solve anything in the 
> short run _or_ the long run.

Linus stop and think for a minute instead. Maybe a timeline would help


		Nouveau development starts
		People ship highly experimental stuff for testers
		Code gets to the "works but really needs a clean up point"

		Linus demands it is merged
		Linus gets it merged as staging

		Developers start doing the cleanup

		Linus throws a tantrum because they did the cleanup after
		merge


*YOU* forced the early merge (rightly or wrongly)
*YOU* effectively created the API break problem

So blaming other people is quite out of order.

Alan
