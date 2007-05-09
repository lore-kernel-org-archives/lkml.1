Return-Path: <linux-kernel-owner+w=401wt.eu-S1757847AbXEILI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757847AbXEILI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 07:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755214AbXEILIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 07:08:04 -0400
Received: from alephnull.demon.nl ([83.160.184.112]:51726 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757306AbXEILIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 07:08:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:in-reply-to:user-agent;
	b=Bxsq0IfpWLHJRaMbpc+07cR4Qla66lZT1094VhWL4rSVKChZ8Pt1Hxda1YOaV
	P/q1w/6bp+aG1Wy+ycBfPZA1Q==
Date: Wed, 9 May 2007 13:07:59 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: marcus@better.se, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Intel IXP4xx network drivers v.2 - Ethernet and HSS
Message-ID: <20070509110759.GB7513@xi.wantstofly.org>
References: <200705091035.l49AZeto017530@harpo.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705091035.l49AZeto017530@harpo.it.uu.se>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 12:35:40PM +0200, Mikael Pettersson wrote:

> > > Does that mean that the Debian ARM people have their heads so far
> > > up their collective asses that they think that every form of change
> > > is bad and are unable to accept that some forms of change might be
> > > for the better?
> > 
> > Well, I am not one of the Debian ARM people, just a user... and I
> > do hope the EABI port becomes supported in the future! But in the
> > meatime there is a crowd of users running Debian on consumer devices
> > like the NSLU2, and they need a LE network driver.
> 
> 1) Development _should_ happen in small individually-manageable steps.
>    It's wrong to delay integration of the new IXP4xx eth driver just
>    because it's not yet LE-compatible.

Exactly.


> 2) LE Debian/ARM users do have alternatives: they can use USB-Ethernet
>    adapters, for instance.

Or just use Christian's driver.
